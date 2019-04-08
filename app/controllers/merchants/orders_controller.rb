class Merchants::OrdersController < Merchants::BaseController
  def index
    @merchant = current_user
    @pending_orders = Order.where(id: @merchant.pending_orders)
  end
end
