class ItemsController < ApplicationController
  def index
    @items = Item.enabled_items
    @top_5 = Item.sort_sold(:desc)
  end
end
