class UsersController < ApplicationController
  before_action :require_user, except: [:new, :create]
  # skip_before_action :require_user, only: [:new, :create]
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if user_info[:password] == ""
      @user.update(user_info.except(:password))
    elsif user_info[:password]
      @user.update(user_info)
    end
    if @user.save
      flash[:notice] = "You have updated your information."
      redirect_to profile_path
    else
      render :edit
    end
  end

  def create
    if passwords_dont_match
      redisplay_new_form "Passwords do not match"

    elsif incomplete_information
      redisplay_new_form "Please fill in all fields"

    elsif email_in_use
      @user = User.new(user_info.except(:email))
      flash[:info] = "E-Mail already in use"
      render :new

    else
      @user = User.create(user_info)
      flash[:info] = "You are now registered and logged in"
      redirect_to profile_path
    end
  end

  def new
    unless current_visitor?
      flash[:info] = "You are already registered"
      redirect_to root_path
    end
    @user = User.new
  end

  private

  def redisplay_new_form(message, pre_fill = form_info)
    @user = User.new
    flash[:info] = message
    redirect_to register_path pre_fill
  end

  def passwords_dont_match
    params[:user][:password] != params[:user][:password_confirmation]
  end

  def incomplete_information
    user_info.to_hash.any?{|key, value| value == ""}
  end

  def email_in_use
    User.exists?(email: params[:user][:email])
  end

  def user_info
    params
    .require(:user)
    .permit(:name, :street_address, :city, :state, :zip_code, :email,
      :password)
  end

  def form_info
    user_info.except(:password).to_hash
  end

  def require_user
    render file: "/public/404" unless current_user?
  end

end
