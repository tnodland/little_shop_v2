class Admin::UsersController < Admin::BaseController
  def index
    @users = User.where(role: 0)
  end

  def show
    @user = User.find(params[:id])
    if @user.merchant?
      redirect_to admin_merchant_path(@user)
    end
  end

  def upgrade
    user = User.find(params[:id])
    if user.user?
      user.role = 1
      user.save
      flash[:notice] = "#{user.name} is now a Merchant"
      redirect_to admin_merchant_path(user)
    end
  end
end
