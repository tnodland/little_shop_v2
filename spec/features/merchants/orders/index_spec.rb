require 'rails_helper'

RSpec.describe 'Merchant Item Index', type: :feature do
  before :each do
    @merchant = create(:merchant)
    @users = create_list(:user, 2))
    @items = create_list(:item, 2,  user: @merchant)

    @order_1 = create(:order, user: @users[0])
    @order_2 = create(:order, user: @users[1])
    @shipped_order = create(:shipped_order, user: @users[1])

    @order_items_1 = create(:order_item, item:@items[0], order:@order_1)
    @order_items_2 = create(:order_item, item:@items[0], order:@order_2)
    @order_items_3 = create(:order_item, item:@items[1], order:@order_2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
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
      expect(page).to have_link(@order_1.id, dashboard_order_path(@order_1))
      expect(page).to have_content(@order_1.created_at)
      expect(page).to have_content(@order_1.total_count)
      expect(page).to have_content(@order_1.total_cost)
    end

    within "#order-#{@order_2.id}" do
      expect(page).to have_link(@order_2.id, dashboard_order_path(@order_2))
      expect(page).to have_content(@order_2.created_at)
      expect(page).to have_content(@order_2.total_count)
      expect(page).to have_content(@order_2.total_cost)
    end

    expect(page).not_to have_selector('div', id:"#order=#{@order_3.id}")

  end

end
