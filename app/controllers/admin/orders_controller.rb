class Admin::OrdersController < Admin::BaseController
  include UserOrder

  def index
    @orders = Order.admin_ordered
  end

  def cancel
    super(admin_dashboard_path)
  end

  def update
    order = Order.find(params[:id])
    order.status = params[:status]
    order.save
    redirect_to admin_dashboard_path
  end
end
