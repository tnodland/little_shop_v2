class Users::OrdersController < Users::BaseController

  def index
    @orders = Order.where(user: current_user)
  end
end
