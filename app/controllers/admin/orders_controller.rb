class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.admin_ordered
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    order = Order.find(params[:id])
    order.status = params[:status]
    order.save
    redirect_to admin_dashboard_path
  end
end
