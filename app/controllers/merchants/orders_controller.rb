class Merchants::OrdersController < Merchants::BaseController
  def index
    @merchant = User.find(current_user.id)
    @orders = Order.find_by_merchant(@merchant).where(status: 0)

    respond_to do |format|
      format.html
      format.json {render json: @merchant.graphics_data}
    end
  end

  def show
    merchant = User.find(current_user.id)
    @order = Order.find(params[:id])
    @items = Item.find_by_order(@order, merchant)
  end

  def update
    order = Order.find(params[:order])
    item = Item.find(params[:item])
    order_item = order.order_items.find_by(item_id: item.id)
    item.quantity -= order_item.quantity
    order_item.toggle :fulfilled
    item.save
    order_item.save
    if order.all_fulfilled?
      order.status = 1
      order.save
    end
    flash[:success] = "Item fulfilled!"
    redirect_to dashboard_order_path(order)
  end
end
