require 'rails_helper'

RSpec.describe 'As an Admin User' do
  describe 'dashboard page (orders index) links to admin order show page' do
    before :each do
      @admin = create(:admin)
      @user = create(:user)
      @order_1 = create(:order, user_id: @user.id, status: 0)
      @item_1 = create(:item)
      @item_2 = create(:item)
      @order_item_1 = create(:order_item, quantity: 5, ordered_price: 5.0, order: @order_1, item: @item_1, fulfilled: true)
      @order_item_2 = create(:order_item, quantity: 4, ordered_price: 10.0, order: @order_1, item: @item_2, fulfilled: false)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    it 'can navigate to an order show page' do
      visit admin_dashboard_path

      within "#order-#{@order_1.id}" do
        click_link "Order: #{@order_1.id}"
      end

      expect(current_path).to eq(admin_user_order_path(@order_1.user, @order_1))
    end

    it 'shows information about the order' do
      visit profile_order_path(@order_1)

      within '#order-info' do
        expect(page).to have_content("Order ID: #{@order_1.id}")
        expect(page).to have_content("Order Status: #{@order_1.status}")
        expect(page).to have_content("Order Placed: #{@order_1.created_at.strftime("%m/%d/%Y")}")
        expect(page).to have_content("Last Updated: #{@order_1.updated_at.strftime("%m/%d/%Y")}")
        expect(page).to have_content("QTY of Items: #{@order_1.total_count}")
        expect(page).to have_content("Grand Total: #{@order_1.total_cost}")
      end

      within "#item-#{@item_1.id}" do
        expect(page).to have_xpath("//img[@src='https://vignette.wikia.nocookie.net/animalcrossing/images/7/72/Tom_Nook.png/revision/latest?cb=20101105231130']")
        expect(page).to have_content("Item: #{@item_1.name}")
        expect(page).to have_content("QTY: #{@order_item_1.quantity}")
        expect(page).to have_content("Subtotal: #{@order_item_1.subtotal}")
      end
    end
  end
end
