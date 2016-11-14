class ReservationsController < ApplicationController
  before_action :authenticate_user!, except: [:check]
  before_action :set_reservation, only: [:edit, :update, :destroy, :note]

  def index
    @reservations = params[:old] ? Reservation.old : Reservation.current
    @reservations = @reservations.with_deleted if can? :manage, Reservation
    @reservations = @reservations.order(order_clause).group_by(&:date)

    respond_to { |format| format.html }
  end

  def new
    @reservation = Reservation.new

    respond_to { |format| format.html }
  end

  def create
    @reservation = Reservation.new(reservation_params)

    respond_to do |format|
      if @reservation.save
        flash[:notice] = "Zarezerowano stolik nr #{@reservation.table.number}" \
          " dnia #{@reservation.date} na godzinę #{@reservation.hour}"
        format.html { redirect_to reservations_path }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    respond_to { |format| format.html }
  end

  def update
    @reservation.assign_attributes(reservation_params)

    respond_to do |format|
      if @reservation.save
        flash[:notice] = 'Zaaktualizowano rezerwację'
        format.html { redirect_to reservations_path }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    if params[:note].blank?
      flash[:error] = 'Nie podano powodu odwołania rezerwacji'
      redirect_to :back and return
    end

    @reservation.update_attributes(cancel_reason: params[:note])

    respond_to do |format|
      if @reservation.destroy
        flash[:notice] = 'Pomyślnie anulowano rezerwację'
        format.html { redirect_to reservations_path }
      else
        flash[:notice] = 'Nie udało się anulować rezerwacji'
        format.html { redirect_to :back }
      end
    end
  end

  def note
    respond_to { |format| format.html }
  end

  def check
    if request.post?
      @r = Reservation.current.where(
        client_name: params[:client_name],
        client_phone: params[:client_phone]
      ).first
    end

    respond_to { |format| format.html }
  end

  def restrict_tables
    respond_to do |format|
      date_ids = Table.ids_by_date(params[:date], params[:id])
      people_ids = Table.ids_by_people(params[:people])
      format.json { render json: date_ids & people_ids }
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(
      :date, :hour, :client_phone, :client_name, :people, :table_id
    )
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def order_clause
    "date #{params[:old] ? 'DESC' : 'ASC'}, table_id"
  end
end
