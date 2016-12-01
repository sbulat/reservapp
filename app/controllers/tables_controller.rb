class TablesController < ApplicationController
  before_action :authenticate_user!

  def index
    @tables = Table.order(:number)
    @table = Table.new
  end

  def create
    @table = Table.new(table_parameters)

    respond_to do |format|
      if @table.save
        flash[:notice] = 'Utworzono stolik'
      else
        flash[:error] = 'Wystąpił problem podczas tworzenia stolika'
      end
      format.html { redirect_to tables_path }
    end
  end

  def update
    table = Table.find(params[:id])
    table.seats = params[:seats]

    respond_to do |format|
      if table.save
        format.json { render json: { message: 'success'} }
      else
        format.json { render json: { message: 'error'} }
      end
    end
  end

  def destroy
    table = Table.find(params[:id])

    if table.destroy
      flash[:notice] = 'Pomyślnie usunięto stolik'
    else
      flash[:error] = 'Wystąpił błąd przy usuwaniu stolika'
    end
    respond_to do |format|
      format.html { redirect_to table_path }
    end
  end

  private

  def table_parameters
    params.require(:table).permit(:number, :seats)
  end
end
