require 'rails_helper'

RSpec.describe 'User Order Index', type: :feature do
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

    it 'shows a link on user profile that goes to /profile/orders' do
      visit profile_path

      click_link "View Your Orders"

      expect(current_path).to eq('/profile/orders')
    end

    it 'shows a list of orders for that user' do
      visit profile_orders_path
      within "#order-#{@order_1.id}" do
        expect(page).to have_link("Order ID: #{@order_1.id}")
        expect(page).to have_content("Order Status: #{@order_1.status}")
        expect(page).to have_content("Order Placed: #{@order_1.created_at.strftime("%m/%d/%Y")}")
        expect(page).to have_content("Last Updated: #{@order_1.updated_at.strftime("%m/%d/%Y")}")
        expect(page).to have_content("QTY of Items: #{@order_1.total_count}")
        expect(page).to have_content("Grand Total: #{@order_1.total_cost}")
      end
    end
  end
end
