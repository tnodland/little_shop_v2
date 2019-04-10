class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.admin_ordered
  end

  def show
    @order = Order.find(params[:id])
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
      flash[:notice] = "The order has been cancelled"
      redirect_to admin_dashboard_path
    end
  end

  def update
    order = Order.find(params[:id])
    order.status = params[:status]
    order.save
    redirect_to admin_dashboard_path
  end
end
