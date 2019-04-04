class Admin::MerchantsController < Admin::BaseController
  def show
  end

  def index
    @merchants = User.all_merchants
  end
end
