class Admin::UsersController < Admin::BaseController
  def index
    @users = User.where(role: 0)
  end

  def show
    @user = User.find(params[:id])
  end
end
