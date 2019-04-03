class UsersController <ApplicationController
  def show
    require_user
  end

  def create
    if passwords_dont_match
      redisplay_new_form "Passwords do not match"

    elsif incomplete_information
      redisplay_new_form "Please fill in all fields"

    elsif email_in_use
      redisplay_new_form "E-Mail already in use", form_info.except("email")

    else
      @user = User.create(user_info)
      flash[:info] = "You are now registered and logged in"
      redirect_to profile_path(@user)
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
