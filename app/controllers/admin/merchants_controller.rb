class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = User.find(params[:id])
  end

  def index
    @merchants = User.all_merchants
  end

  def update
    merchant = User.find(params[:merchant_id])
    merchant.toggle :enabled
    merchant.save
    redirect_to admin_merchants_path
  end
end
