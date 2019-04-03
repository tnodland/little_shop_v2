class Profile::OrdersController < Profile::BaseController

  def index
    @orders = Order.where(user: current_user)
  end

  def show
    @order = Order.find(params[:id])
    @line_items = @order.order_items
  end

  def cancel
    order = Order.find(params[:id])
    if order.pending?
      order.order_items.each do |order_item|
        if order_item.fulfilled?
          order_item.fulfilled = false
          order_item.item.quantity += order_item.quantity
          order_item.item.save
          order_item.save
        end
      end
      order.status = 3
      order.save
      flash[:notice] = "Your order has been cancelled"
      redirect_to profile_path
    else
      redirect_to profile_order_path(params[:id])
    end
  end
end
