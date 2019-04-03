class CartsController < ApplicationController
  before_action :require_customer
  def index
  end

  def create
    item = Item.find(params[:item_id])
    @cart.add_item(item.id.to_s)
    session[:cart] = @cart.contents
    flash[:notice] = "You added #{item.name} to your cart"
    redirect_to items_path
  end
  private
    def require_customer
      render file: "/public/404" unless current_customer?
    end
end
