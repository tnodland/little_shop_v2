require 'rails_helper'

RSpec.describe "order show page" do
  context "as a merchant" do
    before :each do
      @merchant1 = create(:merchant)
      @shopper = create(:user)
      @merchant2 = create(:merchant)
      @item1 = create(:item, user: @merchant1)
      @item2 = create(:item, user: @merchant2)
      @item3 = create(:item, user: @merchant1)

      @order = create(:order, user: @shopper)
      @oi1 = create(:order_item, order: @order, item: @item1)
      @oi2 = create(:order_item, order: @order, item: @item2)
      @oi3 = create(:order_item, order: @order, item: @item3)
    end

    it "can see information about an order" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant1)

      visit dashboard_path(@merchant1)

      expect(page).to have_link("Order #{@order.id}")

      click_link("Order #{@order.id}")

      expect(current_path).to eq(dashboard_order_path(@order))

      within "#ordered-item-#{@item1.id}" do
        expect(page).to have_link(@item1.name)
        expect(page).to have_content("Price: $#{@item1.current_price}0")
        expect(page).to have_content("Quantity ordered: #{@oi1.quantity}")
      end

      within "#ordered-item-#{@item3.id}" do
        expect(page).to have_link(@item3.name)
        expect(page).to have_content("Price: $#{@item3.current_price}0")
        expect(page).to have_content("Quantity ordered: #{@oi3.quantity}")
      end

      expect(page).to_not have_content(@item2.name)
    end

    it "can fulfill their portion of an order" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant1)

      visit dashboard_order_path(@order)

      within "#ordered-item-#{@item1.id}" do
        click_link("Fullfill this item")
      end

      expect(current_path).to eq(dashboard_order_path(@order))
      expect(page).to have_content("Item fulfilled!")

      within "#ordered-item-#{@item1.id}" do
        expect(page).to have_content("This item has been fulfilled")
      end
    end

    it "can't fulfill an item without the proper inventory" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant1)

      item = create(:item, quantity: 1, user: @merchant1)
      order4 = create(:order, user: @shopper)
      oi4 = create(:order_item, order: order4, item: item, quantity: 10)

      visit dashboard_order_path(order4)

      within "#ordered-item-#{item.id}" do
        expect(page).to have_content("You do not have enough #{item.name} to fulfill this order, please update your stock")
      end
    end

    it "will set an order to 'packaged' when all items are fulfilled" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant1)

      visit dashboard_order_path(@order)

      within "#ordered-item-#{@item1.id}" do
        click_link("Fullfill this item")
      end

      visit dashboard_order_path(@order)

      within "#ordered-item-#{@item3.id}" do
        click_link("Fullfill this item")
      end

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant2)

      visit dashboard_order_path(@order)

      within "#ordered-item-#{@item2.id}" do
        click_link("Fullfill this item")
      end

      actual_order = Order.first.packaged?
      expect(actual_order).to eq(true)
    end
  end
end
