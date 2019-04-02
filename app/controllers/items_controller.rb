class ItemsController < ApplicationController
  def index
    @items = Item.enabled_items
  end
end
