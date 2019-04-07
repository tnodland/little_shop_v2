class Merchants::ItemsController < Merchants::BaseController
  def index
    @items = Item.where(user: current_user)
  end

  def new
    @item = Item.new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def create
    @item = current_user.items.new(item_info)
    if @item.valid?
      @item.save
      redirect_to dashboard_items_path
    else
      render :new
    end
  end

  def update
    @item = Item.find(params[:id])
    name = @item.name

    if params[:enabled]
      @item.update(enabled: params[:enabled])
      completed_action = params[:enabled] == "true" ? "Enabled": "Disabled"
      flash[:info] = [@item.name, completed_action].join(" ")
      redirect_to dashboard_items_path
    else
      if @item.update(item_info)
        flash[:info] = "#{name} Edited"
        redirect_to dashboard_items_path
      else
        render :edit
      end
    end
  end

  def destroy
    @item = Item.find(params[:id])
    name = @item.name
    @item.destroy
    flash[:info] = "#{name} Deleted"
    redirect_to dashboard_items_path
  end

  private

  def item_info
    params.require(:item).permit(:name, :description, :image_url, :current_price, :quantity)
  end
end
