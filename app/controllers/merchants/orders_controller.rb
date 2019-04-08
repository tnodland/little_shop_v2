class Merchants::OrdersController < Merchants::BaseController
  def index
    @merchant = User.find(current_user.id)
    @orders = Order.find_by_merchant(@merchant).where(status: 0)
  end

  def show
    merchant = User.find(current_user.id)
    @order = Order.find(params[:id])
    @items = Item.find_by_order(@order, merchant)
  end
end
