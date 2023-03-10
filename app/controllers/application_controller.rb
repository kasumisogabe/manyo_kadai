class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login_required
  protect_from_forgery with: :exception
  include SessionsHelper

  private
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to new_session_path unless current_user
  end
end
