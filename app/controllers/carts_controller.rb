class CartsController < ApplicationController
  before_action :require_customer

  def update
    @cart.update_quantity(params[:item_id], params[:Quantity])
    redirect_to cart_path
  end

  def destroy
    session[:cart] = {}
    redirect_to cart_path
  end

  def show
    @items = {}
    @cart.contents.each do |item_id, quantity|
      @items[Item.find(item_id.to_i)] = quantity
    end
    @total = @items.sum{|item,quantity| item.current_price * quantity}
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
      render_404 unless current_customer?
    end
end
