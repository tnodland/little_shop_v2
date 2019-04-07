class Merchants::ItemsController < Merchants::BaseController
  def index
    @items = Item.where(user: current_user)
  end

  def update
    # binding.pry
    @item = Item.find(params[:id])
    @item.update(enabled: params[:enabled])
    completed_action = params[:enabled] == "true" ? "Enabled": "Disabled"
    flash[:info] = [@item.name, completed_action].join(" ")
    redirect_to dashboard_items_path
  end

  def destroy
    @item = Item.find(params[:id])
    name = @item.name
    @item.destroy
    flash[:info] = "#{name} Deleted"
    redirect_to dashboard_items_path
  end
end
