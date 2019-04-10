class Profile::OrdersController < Profile::BaseController
  include UserOrder
  
  def index
    @orders = Order.where(user: current_user)
  end
end
