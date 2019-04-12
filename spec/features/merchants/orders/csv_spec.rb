require 'rails_helper'

RSpec.describe 'Merchant Orders Index (Dashboard)', type: :feature do
  before :each do
    @merchant = create(:merchant)
    @items = create_list(:item, 10,  user: @merchant, quantity: 160)
    @other_merchant = create(:merchant)
    @other_items = create_list(:item, 10, user:@other_merchant)

    @user_wash = create(:user, state:"Washington", city:"Seattle")
    @user_2 = create(:user, state:"Oregon")
    @utah_user = create(:user, state:"Utah", city: "nothere")
    @other_users = create_list(:user, 4, state:"California")

    @other_users.each do |user|
      orders = create_list(:shipped_order, 2, user:user)

      orders.each do |order|
        create(:fulfilled_order_item, ordered_price: 1.0, item:@other_items[2], quantity:2, order:order)
      end
    end

    @top_orders_user = create(:user, state:"Utah")
    @many_orders = create_list(:shipped_order, 50, user:@top_orders_user)
    @many_orders.each do |order|
      create(:fulfilled_order_item, ordered_price: 5.0, item:@items[1], quantity:10, order:order)
    end

    @other_many_orders = create_list(:shipped_order, 50, user:@top_orders_user)
    @other_many_orders.each do |order|
      create(:fulfilled_order_item, ordered_price: 10.0, item:@other_items[1], quantity:10, order:order)
    end

    @top_items_user = create(:user)
    @big_order = create(:shipped_order, user: @top_items_user)
    create(:fulfilled_order_item, ordered_price: 1.0, item:@items[0], quantity:1000, order:@big_order)

    @other_big_order = create(:shipped_order, user: @top_items_user)
      create(:fulfilled_order_item, ordered_price: 2.0, item: @other_items[0], quantity:900, order: @other_big_order)

    @shipped_order_utah = create(:shipped_order, user: @utah_user)
    create(:fulfilled_order_item, ordered_price: 0.1, quantity: 83, item:@items[9], order:@shipped_order_utah)

    @shipped_orders_user_wash = create_list(:shipped_order,4, user: @user_wash)
    create(:fulfilled_order_item, ordered_price: 3.0, quantity: 9, item:@items[9], order:@shipped_orders_user_wash[0])
    create(:fulfilled_order_item, ordered_price: 3.0, quantity: 4, item:@items[2], order:@shipped_orders_user_wash[1])
    create(:fulfilled_order_item, ordered_price: 3.0, quantity: 3, item:@items[3], order:@shipped_orders_user_wash[2])
    create(:fulfilled_order_item, ordered_price: 3.0, quantity: 1, item:@items[8], order:@shipped_orders_user_wash[3])

    @order_1 = create(:order, user: @user_wash)
    @order_2 = create(:order, user: @user_2)
    create(:fulfilled_order_item, item:@items[0], order:@order_1)
    create(:fulfilled_order_item, item:@items[0], order:@order_2)
    create(:fulfilled_order_item, item:@items[1], order:@order_2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
  end

  it 'has a link to two csv pages, one for current users, and one for non-users that are on the site' do
    visit dashboard_path

    expect(page).to have_link("Current Customer Data", href:dashboard_current_csv_path(format: :csv))
    click_link "Current Customer Data"
    expect(page).to have_content("Name")

    visit dashboard_path
    expect(page).to have_link("Potential Customer Data", href:dashboard_potential_csv_path(format: :csv))
    click_link "Potential Customer Data"
    expect(page).to have_content("Name")
  end

end
