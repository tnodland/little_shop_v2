class SessionsController < ApplicationController
  def new
    if @user = current_user
      login_redirect("You are already logged in.")
    end
  end

  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id.to_s
      login_redirect("You are now logged in.")
    else
      flash.now.alert = "Incorrect email address or password."
      render :new
    end
  end

  private

  def login_redirect(message)
    case viewer_category
    when 'user'
      flash.notice = "Welcome back, #{@user.name}! #{message}"
      redirect_to profile_path
    when 'merchant'
      flash.notice = message
      redirect_to dashboard_path
    when 'admin'
      flash.notice = message
      redirect_to root_path
    end
  end
end
