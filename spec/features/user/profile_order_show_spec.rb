require 'rails_helper'

RSpec.describe 'Profile Orders Show', type: :feature do
  describe 'As a Registerd User' do
    before :each do
      @user = create(:user)
      @order_1 = create(:order, user_id: @user.id)
      @item_1 = create(:item)
      create(:order_item, quantity: 5, ordered_price: 5.0, order: @order_1, item: @item_1)
      create(:order_item, quantity: 5, ordered_price: 5.0, order: @order_1, item: @item_1)
      create(:order_item, quantity: 5, ordered_price: 5.0, order: @order_1, item: @item_1)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'is linked to from the order index page' do
      visit profile_orders_path

      click_link "Order ID: #{@order_1.id}"

      expect(current_path).to eq("/profile/orders/#{@order_1.id}")
    end
  end
end
