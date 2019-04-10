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
      visit admin_user_order_path(@order_1.user, @order_1)

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

    it 'lets an admin cancel a pending order' do
      item_1_quantity = @item_1.quantity
      item_2_quantity = @item_2.quantity


      visit profile_order_path(@order_1)

      within '#order-info' do
        expect(page).to have_button("Cancel Order")
        click_button "Cancel Order"
      end

      expect(current_path).to eq(admin_dashboard_path)
      expect(page).to have_content("The order has been cancelled")

      visit admin_user_order_path(@order_1.user, @order_1)

      expect(page).to have_content("cancelled")
      expect(page).to_not have_content("pending")
      expect(page).to_not have_content("packaged")
      expect(page).to_not have_content("shipped")

      updated_order_item_1 = OrderItem.first
      updated_order_item_2 = OrderItem.second
      updated_item_1 = Item.first
      updated_item_2 = Item.second

      expect(updated_order_item_1.fulfilled?).to be_falsey
      expect(updated_order_item_2.fulfilled?).to be_falsey
      expect(updated_item_1.quantity).to eq((item_1_quantity + @order_item_1.quantity))
      expect(updated_item_2.quantity).to eq((item_2_quantity))
    end
  end
end
