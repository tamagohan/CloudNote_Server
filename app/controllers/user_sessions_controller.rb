# -*- coding: utf-8 -*-
class UserSessionsController < ApplicationController
  before_filter :require_user, :only => :destroy
  skip_before_filter :verify_authenticity_token

  def new
   if current_user_session
     current_user_session.destroy
   end
    @user_session = UserSession.new
  end

  # ログイン
  def create
    reset_session
    params.delete(:authenticity_token)
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "ログインしました。"
      TD.event.post('login', { id: current_user.id })
      redirect_back_or_default user_url(current_user)
    else
      flash[:notice] = "ログインに失敗しました。"
      render :action => :new
    end
  end

  def create_api
    reset_session
    @user_session = UserSession.new(params)
    @user_session.save!
    render json: {}
  rescue => e
    Rails.logger.info("#{e.class.name} raised. #{e.message}")
    raise UnauthorizedAccess
  end

  # ログアウト
  def destroy
    current_user_session.destroy
    flash[:notice] = "ログアウトしました。"
    redirect_back_or_default new_user_session_url
  end
end
