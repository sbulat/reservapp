class ReservationsController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :check]
  before_action :set_reservation, only: [:edit, :update, :destroy, :note]

  def index
    @reservations = params[:old] ? Reservation.old : Reservation.current
    @reservations = @reservations.with_deleted if can? :manage, Reservation
    @reservations = @reservations.order(order_clause).group_by(&:date)

    respond_to { |format| format.html }
  end

  def new
    @r = Reservation.new
    @tables = Table.all.pluck(:id, :number)

    respond_to { |format| format.html }
  end

  def create
    @r = Reservation.new(reservation_params)
    Rails.logger.error reservation_params.inspect
    Rails.logger.error params.inspect
    respond_to do |format|
      if @r.save
        flash[:notice] = t('.reserved', nr: @r.table.number, day: @r.date, hour: @r.hour)
        format.html { redirect_to(user_signed_in? ? reservations_path : reservations_check_path) }
      else
        @tables = Table.all.pluck(:id, :number)
        format.html { render :new }
      end
    end
  end

  def edit
    respond_to { |format| format.html }
  end

  def update
    approved_then = @r.approved
    @r.assign_attributes(reservation_params)

    respond_to do |format|
      if @r.save
        flash[:notice] = t('.updated')
        @r.send_sms if !approved_then && @r.approved
        format.html { redirect_to reservations_path }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    redirect_to(:back, alert: t('.reason_empty')) && return if params[:note].blank?

    @r.update_attributes(cancel_reason: params[:note])

    respond_to do |format|
      if @r.destroy
        format.html { redirect_to reservations_path, notice: t('.success') }
      else
        format.html { redirect_to :back, alert: t('.error') }
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
      )
    end

    respond_to { |format| format.html }
  end

  private

  def reservation_params
    params.require(:reservation).permit(
      :date, :hour, :client_phone, :client_name, :people, :table_id, :approved, :picked_up
    )
  end

  def set_reservation
    @r = Reservation.find(params[:id])
  end

  def order_clause
    "date #{params[:old] ? 'DESC' : 'ASC'}, table_id"
  end
end
