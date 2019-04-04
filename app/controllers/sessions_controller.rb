class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id.to_s
      login_redirect
    else
      flash.now.alert = "Incorrect email address or password."
      render :new
    end
  end

  private

  def login_redirect
    case viewer_category
    when 'user'
      flash.notice = "Welcome back, #{@user.name}! You are now logged in."
      redirect_to profile_path
    when 'merchant'
      flash.notice = "You are now logged in."
      redirect_to dashboard_path
    when 'admin'
      flash.notice = "You are now logged in."
      redirect_to root_path
    end
  end
end
