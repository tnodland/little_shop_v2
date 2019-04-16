require 'rails_helper'

RSpec.describe "Merchant index page" do

  describe 'as an admin user' do
    it 'shows the same information but with disable buttons' do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)
      merchant4 = create(:merchant, enabled: false)
      admin = create(:admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit merchants_path

      expect(page).to have_content("Disable this Merchant")
      expect(page).to have_content("Enable this Merchant")

    end
  end

  context "any type of user can see statistics about merchants" do
    it "can see top ten sellers this month" do
      shopper = create(:user)
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)
      merchant4 = create(:merchant)
      merchant5 = create(:merchant)
      merchant6 = create(:merchant)
      merchant7 = create(:merchant)
      merchant8 = create(:merchant)
      merchant9 = create(:merchant)
      merchant10 = create(:merchant)
      merchant11 = create(:merchant)

      item1 = create(:item, user: merchant1, quantity: 20)
      item2 = create(:item, user: merchant2, quantity: 20)
      item3 = create(:item, user: merchant3, quantity: 20)
      item4 = create(:item, user: merchant4, quantity: 20)
      item5 = create(:item, user: merchant5, quantity: 20)
      item6 = create(:item, user: merchant6, quantity: 20)
      item7 = create(:item, user: merchant7, quantity: 20)
      item8 = create(:item, user: merchant8, quantity: 20)
      item9 = create(:item, user: merchant9, quantity: 20)
      item10 = create(:item, user: merchant10, quantity: 20)
      item11 = create(:item, user: merchant11, quantity: 20)

      order = create(:shipped_order, user: shopper)

      create(:fulfilled_order_item, item: item1, order: order, quantity: 20)
      create(:fulfilled_order_item, item: item2, order: order, quantity: 19)
      create(:fulfilled_order_item, item: item3, order: order, quantity: 18)
      create(:fulfilled_order_item, item: item4, order: order, quantity: 17)
      create(:fulfilled_order_item, item: item5, order: order, quantity: 16)
      create(:fulfilled_order_item, item: item6, order: order, quantity: 15)
      create(:fulfilled_order_item, item: item7, order: order, quantity: 14)
      create(:fulfilled_order_item, item: item8, order: order, quantity: 13)
      create(:fulfilled_order_item, item: item9, order: order, quantity: 12)
      create(:fulfilled_order_item, item: item10, order: order, quantity: 11)
      create(:fulfilled_order_item, item: item11, order: order, quantity: 10)

      visit merchants_path

      within "#top-ten-this-month" do
        expect(page.all("#merchant")[0]).to have_content(merchant1.name)
        expect(page.all("#merchant")[1]).to have_content(merchant2.name)
        expect(page.all("#merchant")[2]).to have_content(merchant3.name)
        expect(page.all("#merchant")[3]).to have_content(merchant4.name)
        expect(page.all("#merchant")[4]).to have_content(merchant5.name)
        expect(page.all("#merchant")[5]).to have_content(merchant6.name)
        expect(page.all("#merchant")[6]).to have_content(merchant7.name)
        expect(page.all("#merchant")[7]).to have_content(merchant8.name)
        expect(page.all("#merchant")[8]).to have_content(merchant9.name)
        expect(page.all("#merchant")[9]).to have_content(merchant10.name)
        expect(page).to_not have_content(merchant11.name)
      end
    end

    it "can see top sellers of last month" do
      shopper = create(:user)
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)
      merchant4 = create(:merchant)
      merchant5 = create(:merchant)
      merchant6 = create(:merchant)
      merchant7 = create(:merchant)
      merchant8 = create(:merchant)
      merchant9 = create(:merchant)
      merchant10 = create(:merchant)
      merchant11 = create(:merchant)

      item1 = create(:item, user: merchant1, quantity: 20)
      item2 = create(:item, user: merchant2, quantity: 20)
      item3 = create(:item, user: merchant3, quantity: 20)
      item4 = create(:item, user: merchant4, quantity: 20)
      item5 = create(:item, user: merchant5, quantity: 20)
      item6 = create(:item, user: merchant6, quantity: 20)
      item7 = create(:item, user: merchant7, quantity: 20)
      item8 = create(:item, user: merchant8, quantity: 20)
      item9 = create(:item, user: merchant9, quantity: 20)
      item10 = create(:item, user: merchant10, quantity: 20)
      item11 = create(:item, user: merchant11, quantity: 20)

      order = create(:shipped_order, user: shopper)

      create(:fulfilled_order_item, item: item1, order: order, quantity: 20, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create(:fulfilled_order_item, item: item2, order: order, quantity: 19, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create(:fulfilled_order_item, item: item3, order: order, quantity: 18, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create(:fulfilled_order_item, item: item4, order: order, quantity: 17, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create(:fulfilled_order_item, item: item5, order: order, quantity: 16, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create(:fulfilled_order_item, item: item6, order: order, quantity: 15, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create(:fulfilled_order_item, item: item7, order: order, quantity: 14, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create(:fulfilled_order_item, item: item8, order: order, quantity: 13, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create(:fulfilled_order_item, item: item9, order: order, quantity: 12, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create(:fulfilled_order_item, item: item10, order: order, quantity: 11, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create(:fulfilled_order_item, item: item11, order: order, quantity: 10, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")

      visit merchants_path

      within "#top-ten-last-month" do
        expect(page.all("#merchant")[0]).to have_content(merchant1.name)
        expect(page.all("#merchant")[1]).to have_content(merchant2.name)
        expect(page.all("#merchant")[2]).to have_content(merchant3.name)
        expect(page.all("#merchant")[3]).to have_content(merchant4.name)
        expect(page.all("#merchant")[4]).to have_content(merchant5.name)
        expect(page.all("#merchant")[5]).to have_content(merchant6.name)
        expect(page.all("#merchant")[6]).to have_content(merchant7.name)
        expect(page.all("#merchant")[7]).to have_content(merchant8.name)
        expect(page.all("#merchant")[8]).to have_content(merchant9.name)
        expect(page.all("#merchant")[9]).to have_content(merchant10.name)
        expect(page).to_not have_content(merchant11.name)
      end
    end

    it "can see top ten at fulfilling orders this month" do
      shopper = create(:user)
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)
      merchant4 = create(:merchant)
      merchant5 = create(:merchant)
      merchant6 = create(:merchant)
      merchant7 = create(:merchant)
      merchant8 = create(:merchant)
      merchant9 = create(:merchant)
      merchant10 = create(:merchant)
      merchant11 = create(:merchant)

      item1 = create(:item, user: merchant1, quantity: 100)
      item2 = create(:item, user: merchant2, quantity: 100)
      item3 = create(:item, user: merchant3, quantity: 100)
      item4 = create(:item, user: merchant4, quantity: 100)
      item5 = create(:item, user: merchant5, quantity: 100)
      item6 = create(:item, user: merchant6, quantity: 100)
      item7 = create(:item, user: merchant7, quantity: 100)
      item8 = create(:item, user: merchant8, quantity: 100)
      item9 = create(:item, user: merchant9, quantity: 100)
      item10 = create(:item, user: merchant10, quantity: 100)
      item11 = create(:item, user: merchant11, quantity: 100)

      order = create(:shipped_order, user: shopper)

      create_list(:fulfilled_order_item, 10, item: item1, order: order, quantity: 1)
      create_list(:fulfilled_order_item, 9, item: item2, order: order, quantity: 1)
      create_list(:fulfilled_order_item, 8, item: item3, order: order, quantity: 1)
      create_list(:fulfilled_order_item, 7, item: item4, order: order, quantity: 1)
      create_list(:fulfilled_order_item, 6, item: item5, order: order, quantity: 1)
      create_list(:fulfilled_order_item, 5, item: item6, order: order, quantity: 1)
      create_list(:fulfilled_order_item, 4, item: item7, order: order, quantity: 1)
      create_list(:fulfilled_order_item, 3, item: item8, order: order, quantity: 1)
      create_list(:fulfilled_order_item, 2, item: item9, order: order, quantity: 1)
      create_list(:fulfilled_order_item, 1, item: item10, order: order, quantity: 1)

      visit merchants_path

      within "#top-ten-fulfillers-this-month" do
        expect(page.all("#merchant")[0]).to have_content(merchant1.name)
        expect(page.all("#merchant")[1]).to have_content(merchant2.name)
        expect(page.all("#merchant")[2]).to have_content(merchant3.name)
        expect(page.all("#merchant")[3]).to have_content(merchant4.name)
        expect(page.all("#merchant")[4]).to have_content(merchant5.name)
        expect(page.all("#merchant")[5]).to have_content(merchant6.name)
        expect(page.all("#merchant")[6]).to have_content(merchant7.name)
        expect(page.all("#merchant")[7]).to have_content(merchant8.name)
        expect(page.all("#merchant")[8]).to have_content(merchant9.name)
        expect(page.all("#merchant")[9]).to have_content(merchant10.name)
        expect(page).to_not have_content(merchant11.name)
      end
    end

    it "can see top ten at fulfilling orders last month" do
      shopper = create(:user)
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)
      merchant4 = create(:merchant)
      merchant5 = create(:merchant)
      merchant6 = create(:merchant)
      merchant7 = create(:merchant)
      merchant8 = create(:merchant)
      merchant9 = create(:merchant)
      merchant10 = create(:merchant)
      merchant11 = create(:merchant)

      item1 = create(:item, user: merchant1, quantity: 100)
      item2 = create(:item, user: merchant2, quantity: 100)
      item3 = create(:item, user: merchant3, quantity: 100)
      item4 = create(:item, user: merchant4, quantity: 100)
      item5 = create(:item, user: merchant5, quantity: 100)
      item6 = create(:item, user: merchant6, quantity: 100)
      item7 = create(:item, user: merchant7, quantity: 100)
      item8 = create(:item, user: merchant8, quantity: 100)
      item9 = create(:item, user: merchant9, quantity: 100)
      item10 = create(:item, user: merchant10, quantity: 100)
      item11 = create(:item, user: merchant11, quantity: 100)

      order = create(:shipped_order, user: shopper)

      create_list(:fulfilled_order_item, 10, item: item1, order: order, quantity: 1, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create_list(:fulfilled_order_item, 9, item: item2, order: order, quantity: 1, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create_list(:fulfilled_order_item, 8, item: item3, order: order, quantity: 1, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create_list(:fulfilled_order_item, 7, item: item4, order: order, quantity: 1, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create_list(:fulfilled_order_item, 6, item: item5, order: order, quantity: 1, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create_list(:fulfilled_order_item, 5, item: item6, order: order, quantity: 1, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create_list(:fulfilled_order_item, 4, item: item7, order: order, quantity: 1, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create_list(:fulfilled_order_item, 3, item: item8, order: order, quantity: 1, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create_list(:fulfilled_order_item, 2, item: item9, order: order, quantity: 1, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")
      create_list(:fulfilled_order_item, 1, item: item10, order: order, quantity: 1, created_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00", updated_at: "Sat, 16 Mar 2019 01:34:03 UTC +00:00")

      visit merchants_path

      within "#top-ten-fulfillers-last-month" do
        expect(page.all("#merchant")[0]).to have_content(merchant1.name)
        expect(page.all("#merchant")[1]).to have_content(merchant2.name)
        expect(page.all("#merchant")[2]).to have_content(merchant3.name)
        expect(page.all("#merchant")[3]).to have_content(merchant4.name)
        expect(page.all("#merchant")[4]).to have_content(merchant5.name)
        expect(page.all("#merchant")[5]).to have_content(merchant6.name)
        expect(page.all("#merchant")[6]).to have_content(merchant7.name)
        expect(page.all("#merchant")[7]).to have_content(merchant8.name)
        expect(page.all("#merchant")[8]).to have_content(merchant9.name)
        expect(page.all("#merchant")[9]).to have_content(merchant10.name)
        expect(page).to_not have_content(merchant11.name)
      end
    end

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
        expect(page).to have_content("#{merchant4.name}, making $100.00 in revenue")
        expect(page).to have_content("#{merchant3.name}, making $75.00 in revenue")
        expect(page).to have_content("#{merchant2.name}, making $50.00 in revenue")
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
        expect(page).to have_content("#{merchant1.name} averages #{merchant1.average_time} days to fill orders")
        expect(page).to have_content("#{merchant2.name} averages #{merchant2.average_time} days to fill orders")
        expect(page).to have_content("#{merchant3.name} averages #{merchant3.average_time} days to fill orders")
        expect(page).to_not have_content(merchant4.name)
      end

      within "#slowest-merchants" do
        expect(page).to have_content("#{merchant4.name} averages #{merchant4.average_time} days to fill orders")
        expect(page).to have_content("#{merchant3.name} averages #{merchant3.average_time} days to fill orders")
        expect(page).to have_content("#{merchant2.name} averages #{merchant2.average_time} days to fill orders")
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

    it "shows 3 most popular cities and states" do
      shopper1 = create(:user, city: "Denver", state: "Colorado")
      shopper2 = create(:user, city: "St Paul", state: "Minnesota")
      shopper3 = create(:user, city: "Las Vegas", state: "Nevada")
      shopper4 = create(:user, city: "Las Angeles", state: "California")
      order1 = create(:shipped_order, user: shopper1)
      order1 = create(:shipped_order, user: shopper1)
      order1 = create(:shipped_order, user: shopper1)
      order1 = create(:shipped_order, user: shopper1)
      order2 = create(:shipped_order, user: shopper2)
      order2 = create(:shipped_order, user: shopper2)
      order2 = create(:shipped_order, user: shopper2)
      order3 = create(:shipped_order, user: shopper3)
      order3 = create(:shipped_order, user: shopper3)
      order4 = create(:shipped_order, user: shopper4)


      visit merchants_path

      within "#top-three-cities" do
        expect(page).to have_content("4 orders have been shipped to #{shopper1.city}")
        expect(page).to have_content("3 orders have been shipped to #{shopper2.city}")
        expect(page).to have_content("2 orders have been shipped to #{shopper3.city}")
      end

      within "#top-three-states" do
        expect(page).to have_content("4 orders have been shipped to #{shopper1.state}")
        expect(page).to have_content("3 orders have been shipped to #{shopper2.state}")
        expect(page).to have_content("2 orders have been shipped to #{shopper3.state}")
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
        expect(page).to have_content(@merchant.name)
        expect(page).to have_link("#{@merchant.name}")
        expect(page).to have_content("Located in #{@merchant.city}, #{@merchant.state}")
        expect(page).to have_content("Joined the store on #{@merchant.created_at}")
        expect(page).to have_link("Disable this Merchant")
      end

      within "#merchant-#{@im.id}" do
        expect(page).to have_content(@im.name)
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
