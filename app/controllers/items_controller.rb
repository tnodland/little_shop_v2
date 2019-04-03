class ItemsController < ApplicationController
  def index
    @items = Item.enabled_items
    @top_5 = Item.sort_sold("DESC")
    @bottom_5 = Item.sort_sold("ASC")
  end

  def show
  end
end
