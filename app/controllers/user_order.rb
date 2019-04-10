module UserOrder
  def show
    @order = Order.find(params[:id])
  end

  def cancel(redirect_path = profile_path)
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
      redirect_to redirect_path
    end
  end
end
