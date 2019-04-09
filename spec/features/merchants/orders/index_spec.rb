require 'rails_helper'

RSpec.describe 'Merchant Orders Index (Dashboard)', type: :feature do
  before :each do
    @merchant = create(:merchant)
    @items = create_list(:item, 10,  user: @merchant)

    @user_1 = create(:user, state:"Washington")
    @user_2 = create(:user, state:"Oregon")

    @top_orders_user = create(:user, state:"Utah")
    @many_orders = create_list(:shipped_order, 500, user:@top_orders_user)
    @many_orders.each do |order|
      create(:order_item, item:@items[1], quantity:1, order:order)
    end

    @top_items_user = create(:user)
    @big_order = create(:shipped_order, user: @top_items_user)
    create(:order_item, item:@items[0], quantity:1000, order:@big_order)

    @order_1 = create(:order, user: @user_1)
    @order_2 = create(:order, user: @user_2)
    @shipped_order = create(:shipped_order, user: @user_1)

    @order_items_1 = create(:order_item, item:@items[0], order:@order_1)
    @order_items_2 = create(:order_item, item:@items[0], order:@order_2)
    @order_items_3 = create(:order_item, item:@items[1], order:@order_2)
    @order_items_4 = create(:order_item, quantity: 4, item:@items[0], order:@shipped_order)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
  end

  it 'shows top 5 items by quanity sold, and quantity of each sold'
  it 'shows percentage of inventory sold (sold / sold+remaining)'
  it 'shows top 3 states where orders have shipped'
  it 'shows top 3 cities (state dependent) where orders were shipped and quantity'
  it 'shows name of user with msot orders and number of orders'
  it 'shows name of user who ordered most items'
  it 'shows top 3 users by money spent, and total amount spent'

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
