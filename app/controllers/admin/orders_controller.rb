class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.admin_ordered
  end
end
