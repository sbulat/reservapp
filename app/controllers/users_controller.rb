class UsersController < ApplicationController
  before_action :authenticate_manager!, except: [:edit, :update]
  before_action :set_user, only: [:edit, :update, :destroy, :promote]
  skip_before_action :require_no_authentication

  def index
    @users = User.all

    @user = User.new
    respond_to { |format| format.html }
  end

  def create
    user = User.new(user_params)

    if user.save
      flash[:notice] = 'Utworzono nowego pracownika'
    else
      flash[:alert] = 'Wystąpił błąd podczas zapisu'
    end

    respond_to do |format|
      format.html { redirect_to users_path }
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = 'Pomyślnie usunięto użytkownika'
    else
      flash[:alert] = 'Wystąpił błąd podczas usuwania'
    end

    respond_to do |format|
      format.html { redirect_to users_path }
    end
  end

  def promote
    @user.roles = 'manager'

    if @user.save
      flash[:notice] = 'Awansowano użytkownika na managera'
    else
      flash[:alert] = 'Wystąpił błąd podczas zapisu'
    end
    respond_to do |format|
      format.html { redirect_to users_path }
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
