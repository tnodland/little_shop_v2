require 'rails_helper'

RSpec.describe "Merchant index page" do
  context "any type of user can see statistics about merchants" do
    it "shows top 3 merchants by price and quantity" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)
      merchant4 = create(:merchant)
      shopper = create(:user)
      item1 = create(:item, quantity: 100, user: merchant1)
      item2 = create(:item, quantity: 100, user: merchant2)
      item3 = create(:item, quantity: 100, user: merchant3)
      item4 = create(:item, quantity: 100, user: merchant4)
      order = create(:shipped_order, user: shopper)
      create(:fulfilled_order_item, order: order, item: item1, quantity: 10)
      create(:fulfilled_order_item, order: order, item: item2, quantity: 20)
      create(:fulfilled_order_item, order: order, item: item3, quantity: 30)
      create(:fulfilled_order_item, order: order, item: item4, quantity: 40)

      visit merchants_path

      within "#top-three-sellers" do
        expect(page).to have_content("#{merchant4.name}, making #{merchant4.total_revenue} in revenue")
        expect(page).to have_content("#{merchant3.name}, making #{merchant3.total_revenue} in revenue")
        expect(page).to have_content("#{merchant2.name}, making #{merchant2.total_revenue} in revenue")
        expect(page).to_not have_content(merchant1.name)
      end
    end

    it "shows 3 fastest and slowest merchants" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)
      merchant4 = create(:merchant)
      shopper = create(:user)
      item1 = create(:item, quantity: 100, user: merchant1)
      item2 = create(:item, quantity: 100, user: merchant2)
      item3 = create(:item, quantity: 100, user: merchant3)
      item4 = create(:item, quantity: 100, user: merchant4)
      order = create(:shipped_order, user: shopper)
      create(:fast_fulfilled_order_item, order: order, item: item1)
      create(:fast_fulfilled_order_item, order: order, item: item1)
      create(:fast_fulfilled_order_item, order: order, item: item1)
      create(:fast_fulfilled_order_item, order: order, item: item2)
      create(:fast_fulfilled_order_item, order: order, item: item2)
      create(:slow_fulfilled_order_item, order: order, item: item2)
      create(:fast_fulfilled_order_item, order: order, item: item3)
      create(:slow_fulfilled_order_item, order: order, item: item3)
      create(:slow_fulfilled_order_item, order: order, item: item3)
      create(:slow_fulfilled_order_item, order: order, item: item4)
      create(:slow_fulfilled_order_item, order: order, item: item4)
      create(:slow_fulfilled_order_item, order: order, item: item4)

      visit merchants_path

      within "#fastest-merchants" do
        expect(page).to have_content("#{merchant1.name} takes on average #{merchant1.average_time} days to complete an order")
        expect(page).to have_content("#{merchant2.name} takes on average #{merchant2.average_time} days to complete an order")
        expect(page).to have_content("#{merchant3.name} takes on average #{merchant3.average_time} days to complete an order")
        expect(page).to_not have_content(merchant4.name)
      end

      within "#slowest-merchants" do
        expect(page).to have_content("#{merchant4.name} takes on average #{merchant4.average_time} days to complete an order")
        expect(page).to have_content("#{merchant3.name} takes on average #{merchant3.average_time} days to complete an order")
        expect(page).to have_content("#{merchant2.name} takes on average #{merchant2.average_time} days to complete an order")
        expect(page).to_not have_content(merchant1.name)
      end
    end

    it "shows 3 largest orders" do
      merchant1 = create(:merchant)
      shopper = create(:user)
      item1 = create(:item, quantity: 100, user: merchant1)
      order1 = create(:shipped_order, user: shopper)
      order2 = create(:shipped_order, user: shopper)
      order3 = create(:shipped_order, user: shopper)
      order4 = create(:shipped_order, user: shopper)
      create(:fulfilled_order_item, order: order1, item: item1, quantity: 20)
      create(:fulfilled_order_item, order: order2, item: item1, quantity: 15)
      create(:fulfilled_order_item, order: order3, item: item1, quantity: 10)
      create(:fulfilled_order_item, order: order4, item: item1, quantity: 5)

      visit merchants_path

      within "#3-largest-orders" do
        expect(page).to have_content("Order #{order1.id} with #{order1.total_count} items sold")
        expect(page).to have_content("Order #{order2.id} with #{order2.total_count} items sold")
        expect(page).to have_content("Order #{order3.id} with #{order3.total_count} items sold")
        expect(page).to_not have_content("Order #{order4.id} with #{order4.total_count} items sold")
      end
    end
  end


  context "as any non admin user" do
    it "can see all merchants and some information" do
      merchants = create_list(:merchant, 3)
      im = create(:inactive_merchant)

      visit merchants_path

      merchants.each do |merchant|
        within "#merchant-#{merchant.id}" do
          expect(page).to have_content(merchant.name)
          expect(page).to have_content("Located in #{merchant.city}, #{merchant.state}")
          expect(page).to have_content("Joined the store on #{merchant.created_at}")
        end
      end

      expect(page).to_not have_content("Name: #{im.name}")
    end
  end

  context "as an admin user" do
    before :each do
      @merchant = create(:merchant)
      @im = create(:inactive_merchant)
      @admin = create(:admin)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    it "sees different information than other users" do
      visit admin_merchants_path

      within "#merchant-#{@merchant.id}" do
        expect(page).to have_content("Name: #{@merchant.name}")
        expect(page).to have_link("#{@merchant.name}")
        expect(page).to have_content("Located in #{@merchant.city}, #{@merchant.state}")
        expect(page).to have_content("Joined the store on #{@merchant.created_at}")
        expect(page).to have_link("Disable this Merchant")
      end

      within "#merchant-#{@im.id}" do
        expect(page).to have_content("Name: #{@im.name}")
        expect(page).to have_link("#{@im.name}")
        expect(page).to have_content("Located in #{@im.city}, #{@im.state}")
        expect(page).to have_content("Joined the store on #{@im.created_at}")
        expect(page).to have_link("Enable this Merchant")
      end
    end

    it "can disable a merchant" do
      visit admin_merchants_path

      within "#merchant-#{@merchant.id}" do
        click_link("Disable this Merchant")
      end

      expect(current_path).to eq(admin_merchants_path)

      within "#merchant-#{@merchant.id}" do
        expect(page).to have_link("Enable this Merchant")
      end
    end

    it "can enable a merchant" do
      visit admin_merchants_path

      within "#merchant-#{@im.id}" do
        click_link("Enable this Merchant")
      end

      expect(current_path).to eq(admin_merchants_path)

      within "#merchant-#{@im.id}" do
        expect(page).to have_link("Disable this Merchant")
      end
    end
  end
end
