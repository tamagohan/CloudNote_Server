# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user_session, :current_user

  rescue_from StandardError do |e|
    render_exception(e)
  end

  private

  #################### Authlogic
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def store_location
    session[:return_to] = request.url
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = 'ログインしてください。'
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = 'ログアウトしてください。'
      redirect_to user_url(current_user)
      return false
    end
  end
  #################### Authlogic



  #################### Custom Error
  class UnauthorizedAccess < StandardError
  end

  def render_exception(e)
    Rails.logger.info("#{e.class.name} raised. #{e.message}")
    p "#{e.class.name} raised. #{e.message}"
    case e
    when UnauthorizedAccess           then status = :forbidden
    when ActiveRecord::RecordNotFound then status = :not_found
    else
      status = :service_unavailable
    end
    render json: {error_message: e.message} , status: status
    return false
  end
  #################### Custom Error
end
