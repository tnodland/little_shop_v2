class Profile::OrdersController < Profile::BaseController

  def index
    @orders = Order.where(user: current_user)
  end

  def show
    @order = Order.find(params[:id])
    @line_items = @order.order_items
  end
end
