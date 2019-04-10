class Merchants::OrdersController < Merchants::BaseController
  def index
    @merchant = User.find(current_user.id)
    @orders = Order.find_by_merchant(@merchant).where(status: 0)
    @top_merchant_items = Item.merchant_top_items(@merchant)
    @top_states = Order.top_states(@merchant)
    @top_cities = Order.top_cities(@merchant)
    @top_user_orders = Order.top_user_orders(@merchant)
    @top_user_items = Order.top_user_items(@merchant)
    @top_users_money = Order.top_users_money(@merchant)
    @pct_sold = Item.pct_sold(@merchant)
    @items_sold = Item.items_sold(@merchant)
  end

  def show
    merchant = User.find(current_user.id)
    @order = Order.find(params[:id])
    @items = Item.find_by_order(@order, merchant)
  end

  def update
    order = Order.find(params[:order])
    item = Item.find(params[:item])
    order_item = item.order_items.first
    item.quantity -= order_item.quantity
    order_item.toggle :fulfilled
    item.save
    order_item.save
    flash[:success] = "Item fulfilled!"
    redirect_to dashboard_order_path(order)
  end
end

# @items_sold = Item.items_sold(merchant)
# @pct_sold = Item.pct_sold(merchant)
