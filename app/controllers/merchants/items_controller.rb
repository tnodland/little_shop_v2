class Merchants::ItemsController < Merchants::BaseController
  def index
    @items = current_user.items
  end
end
