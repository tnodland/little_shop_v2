class MerchantsController < ApplicationController
  def index
    @merchants = User.active_merchants
    @top_three_sellers = @merchants.top_three_sellers
    @fastest_three = @merchants.sort_by_fulfillment(:desc)
    @slowest_three = @merchants.sort_by_fulfillment(:asc)
  end
end
