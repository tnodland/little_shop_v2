class Merchants::ItemsController < Merchants::BaseController
  def index
    @items = Item.where(user: current_user)
  end

  def update
    @item = Item.find(params[:id])
    @item.update(enabled: params[:enabled])

    redirect_to dashboard_items_path
  end
end
