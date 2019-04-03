class UsersController <ApplicationController
  # before_action :require_user
  def show
    require_user
  end

  def create
    # binding.pry
    if passwords_dont_match
      @user = User.new
      flash[:info] = "Passwords do not match"
      redirect_to register_path form_info
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

  def passwords_dont_match
    params[:user][:password] != params[:user][:password_confirmation]
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

  def
  def require_user
    render file: "/public/404" unless current_user?
  end

  def require_visitor
    redirect_to root_path unless current_visitor?
  end
end
