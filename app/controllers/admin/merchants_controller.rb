class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = User.find(params[:id])
    if @merchant.user?
      redirect_to admin_user_path(@merchant)
    end
    @orders = Order.find_by_merchant(@merchant).where(status: 0)
  end

  def index
    @merchants = User.all_merchants

    respond_to do |format|
      format.html
      format.json {render json: User.merchant_performance}
    end
  end

  def update
    merchant = User.find(params[:merchant_id])
    merchant.toggle :enabled
    merchant.save
    redirect_to admin_merchants_path
  end

  def downgrade
    merchant = User.find(params[:id])
    if merchant.merchant?
      merchant.items.each do |item|
        item.enabled = false
        item.save
      end
      merchant.role = 0
      merchant.save
      flash[:notice] = "#{merchant.name} is now a User"
      redirect_to admin_user_path(merchant)
    end
  end
end
