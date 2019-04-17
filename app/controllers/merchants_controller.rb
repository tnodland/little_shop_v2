class MerchantsController < ApplicationController
  def index
    if current_admin?
      @merchants = User.where(role: :merchant)
    else
      @merchants = User.active_merchants
    end
    @top_three_sellers = @merchants.top_three_sellers
    @fastest_three = @merchants.sort_by_fulfillment(:asc)
    @slowest_three = @merchants.sort_by_fulfillment(:desc)
    @three_largest_orders = Order.largest_orders
    @top_three_cities = User.top_three_cities
    @top_three_states = User.top_three_states
    @top_ten_sellers_this_month = @merchants.top_ten_sellers_this_month
    @top_ten_sellers_last_month = @merchants.top_ten_sellers_last_month
    @top_ten_fulfillers_this_month = @merchants.top_ten_fulfillers_this_month
    @top_ten_fulfillers_last_month = @merchants.top_ten_fulfillers_last_month

    if current_user
      @top_five_to_city = User.fastest_to_city(current_user.city)
      @top_five_to_state = User.fastest_to_state(current_user.state)
    end

  end
end
