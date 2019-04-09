require 'rails_helper'

RSpec.describe 'Merchant Orders Index (Dashboard)', type: :feature do
  before :each do
    @merchant = create(:merchant)
    @items = create_list(:item, 10,  user: @merchant, quantity: 8)

    @user_wash = create(:user, state:"Washington", city:"Seattle")
    @user_2 = create(:user, state:"Oregon")
    @utah_user = create(:user, state:"Utah", city: "nothere")

    @top_orders_user = create(:user, state:"Utah")
    @many_orders = create_list(:shipped_order, 500, user:@top_orders_user)
    @many_orders.each do |order|
      create(:fulfilled_order_item, item:@items[1], quantity:1, order:order)
    end

    @top_items_user = create(:user)
    @big_order = create(:shipped_order, user: @top_items_user)
    create(:fulfilled_order_item, item:@items[0], quantity:1000, order:@big_order)

    @shipped_order_utah = create(:shipped_order, user: @utah_user)
    @order_items_7 = create(:fulfilled_order_item, quantity: 83, item:@items[10], order:@shipped_order_utah)

    @shipped_orders_user_wash = create_list(:shipped_order,2, user: @user_wash)
    @order_items_4 = create(:fulfilled_order_item, ordered_proce: 3.0, quantity: 4, item:@items[2], order:@shipped_orders_user_wash[0])
    @order_items_5 = create(:fulfilled_order_item, ordered_proce: 3.0, quantity: 3, item:@items[3], order:@shipped_orders_user_wash[1])
    @order_items_6 = create(:fulfilled_order_item, ordered_proce: 3.0, quantity: 9, item:@items[10], order:@shipped_orders_user_wash[0])
    @order_items_6 = create(:fulfilled_order_item, ordered_proce: 3.0, quantity: 1, item:@items[8], order:@shipped_orders_user_wash[1])

    @order_1 = create(:order, user: @user_wash)
    @order_2 = create(:order, user: @user_2)
    @order_items_1 = create(:fulfilled_order_item, item:@items[0], order:@order_1)
    @order_items_2 = create(:fulfilled_order_item, item:@items[0], order:@order_2)
    @order_items_3 = create(:fulfilled_order_item, item:@items[1], order:@order_2)


    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
  end

  it 'shows top 5 items by quanity sold, and quantity of each sold' do
    visit dashboard_path
    within ".stats" do
      within "#popular-items" do
        items = page.all("li", class:"item")
        expect(items[0]).to have_content("#{@item[0].name}: 1000 sold")
        expect(items[1]).to have_content("#{@item[1].name}: 500 sold")
        expect(items[2]).to have_content("#{@item[10].name}: 92 sold")
        expect(items[3]).to have_content("#{@item[2].name}: 4 sold")
        expect(items[4]).to have_content("#{@item[3].name}: 3 sold")
      end
    end
  end

  it 'shows percentage of inventory sold (sold / sold+remaining)'do
    visit dashboard_path
    within ".stats" do
      within "#percent-sold" do
        expect(page).to have_content("1600 items sold, which is 95.0% of your inventory")
      end
    end
  end

  it 'shows top 3 states where orders have shipped' do
    visit dashboard_path
    within ".stats" do
      within "#top-states" do
        states = page.all("li", class:"state")
        expect(states[0]).to have_content("Utah: 501 orders")
        expect(states[1]).to have_content("Washington: 2 orders")
        expect(states[2]).to have_content("Colorado: 1 orders")
      end
    end
  end

  it 'shows top 3 cities (state dependent) where orders were shipped and quantity' do
    visit dashboard_path
    within ".stats" do
      within "#top-states" do
        city = page.all("li", class:"city")
        expect(city[0]).to have_content("Testville, Utah: 500 orders")
        expect(city[1]).to have_content("Seattle, Washington: 2 orders")
        expect(city[2]).to have_content("Testville, Colorado: 1 order")
      end
    end
  end

  it 'shows name of user with most orders and number of orders' do
    visit dashboard_path
    within ".stats" do
      within "#top-user-orders" do
        expect(page).to have_content("#{@top_orders_user.name}: 500 orders)
      end
    end
  end

  it 'shows name of user who ordered most items' do
    visit dashboard_path
    within ".stats" do
      within "#top-user-items" do
        expect(page).to have_content("#{@top_items_user.name}: 1000 items")
      end
    end
  end
  it 'shows top 3 users by money spent, and total amount spent' do
    visit dashboard_path
    within ".stats" do
      within "#top-users-money" do
        top_sold = page.all("li", class:"user")
        expect(top_sold[0]).to have_content("#{@top_items_user.name}: $2,000.00")
        expect(top_sold[1]).to have_content("#{@top_orders_user.name}: $500.00")
        expect(top_sold[2]).to have_content("#{@top_items_user.name}: $51.00")
      end
    end
  end

  it 'Shows all Profile Information' do
    visit dashboard_path
    expect(page).to have_content(@merchant.name)
    expect(page).to have_content(@merchant.street_address)
    expect(page).to have_content(@merchant.city)
    expect(page).to have_content(@merchant.state)
    expect(page).to have_content(@merchant.zip_code)
    expect(page).to have_content(@merchant.email)
  end

  it 'Shows all pending orders' do
    visit dashboard_path
    within "#order-#{@order_1.id}" do
      expect(page).to have_link(@order_1.id, href:dashboard_order_path(@order_1))
      expect(page).to have_content("Created: #{@order_1.created_at}")
      expect(page).to have_content("Items: #{@order_1.total_count}")
      expect(page).to have_content("Cost: #{@order_1.total_cost}")
    end

    within "#order-#{@order_2.id}" do
      expect(page).to have_link(@order_2.id, href:dashboard_order_path(@order_2))
      expect(page).to have_content(@order_2.created_at)
      expect(page).to have_content(@order_2.total_count)
      expect(page).to have_content(@order_2.total_cost)
    end

    expect(page).not_to have_selector('div', id:"order-#{@shipped_order.id}")

  end

  it 'can navigate to the merchant items page' do
    visit dashboard_path
    click_link "View All Items"
    expect(current_path).to eq(dashboard_items_path)
  end

end
