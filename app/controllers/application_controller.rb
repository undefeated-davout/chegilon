class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ItemsHelper

  before_action :set_paper_trail_whodunnit
  after_action :store_location

  def check
    render plain: 'ok'
  end

  def store_location
    if (request.fullpath != "/users/sign_in" &&
        request.fullpath != "/users/sign_up" &&
        request.fullpath !~ Regexp.new("\\A/users/confirmation.*\\z") &&
        request.fullpath !~ Regexp.new("\\A/users/unlock.*\\z") &&
        request.fullpath !~ Regexp.new("\\A/users/password.*\\z") &&
        !request.xhr?)
      session[:previous_url] = request.fullpath
    end
  end

  # Redirect to previous page after sign in
  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end


  private

  # Checking user login or not
  def logged_in_user
    unless user_signed_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to new_user_session_path
    end
  end
end
