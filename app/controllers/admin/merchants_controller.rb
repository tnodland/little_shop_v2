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

  def downgrade
    merchant = User.find(params[:id])
    # binding.pry
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
