class UsersController <ApplicationController
  # before_action :require_user
  def show
    require_user
  end

  def create
  end
  def new
    unless current_visitor?
      flash[:info] = "You are already registered"
      redirect_to root_path
    end
    @user = User.new


  end

  private
  def require_user
    render file: "/public/404" unless current_user?
  end
  def require_visitor
    redirect_to root_path unless current_visitor?
  end
end
