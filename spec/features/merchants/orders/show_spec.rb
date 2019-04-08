require 'rails_helper'

RSpec.describe "order show page" do
  context "as a merchant" do
    it "can see information about an order" do
      merchant1 = create(:merchant)
      shopper = create(:user)
      merchant2 = create(:merchant)
      item1 = create(:item, user: merchant1)
      item2 = create(:item, user: merchant2)
      item3 = create(:item, user: merchant1)

      order = create(:order, user: shopper)
      oi1 = create(:order_item, order: order, item: item1)
      oi2 = create(:order_item, order: order, item: item2)
      oi3 = create(:order_item, order: order, item: item3)


      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant1)

      visit dashboard_path(merchant1)

      expect(page).to have_link("Order #{order.id}")

      click_link("Order #{order.id}")

      expect(current_path).to eq(dshboard_order_path(order))

      within "ordered_item-#{item1.id}" do
        expect(page).to have_link(item1.name)
        expect(page).to have_content("Price: #{item1.name}")
        expect(page).to have_content("Quantity ordered: #{oi1.quantity}")
      end

      within "ordered_item-#{item3.id}" do
        expect(page).to have_link(item3.name)
        expect(page).to have_content("Price: #{item3.name}")
        expect(page).to have_content("Quantity ordered: #{oi3.quantity}")
      end

      expect(page).to_no have_content(item2.name)
    end
  end
end
