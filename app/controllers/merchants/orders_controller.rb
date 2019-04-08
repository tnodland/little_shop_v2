class Merchants::OrdersController < Merchants::BaseController
  def index
    @merchant = current_user
  end
end
