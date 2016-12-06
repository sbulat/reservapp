class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale

  def index
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def authenticate_manager!
    unless current_user.try(:manager?)
      redirect_to root_path, alert: 'Nie masz dostępu do tej stony!'
      return
    end
  end
end
