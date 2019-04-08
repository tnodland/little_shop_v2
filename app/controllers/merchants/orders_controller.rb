class Merchants::OrdersController < Merchants::BaseController
  def index
    merchant = User.find(current_user.id)
    @orders = Order.find_by_merchant(merchant)
  end
end
