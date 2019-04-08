class OrdersController < ApplicationController
before_action :require_user

  def index
  end

  def create
    Order.from_cart(current_user, @cart.contents)
    flash[:notice] = "Your order was created!"
    redirect_to profile_orders_path
  end

  private

  def require_user
    render_404 unless current_user?
  end
end
