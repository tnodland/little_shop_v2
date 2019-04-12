require 'rails_helper'

RSpec.describe User, type: :model do
  before :each, big_setup:true do
    @merchant = create(:merchant)
    @items = create_list(:item, 10,  user: @merchant, quantity: 160)
    @other_merchant = create(:merchant)
    @other_items = create_list(:item, 10, user:@other_merchant)

    @user_wash = create(:user, name: "A", state:"Washington", city:"Seattle", email:'wash@mail.com')
    @user_oregon = create(:user, name: "B", state:"Oregon")
    @utah_user = create(:user, name: "Z", state:"Utah", city: "nothere")
    @other_users = create_list(:user, 4, state:"California")
    @inactive_users = create_list(:inactive_user, 2)

    @inactive_order = create(:shipped_order, user:@inactive_users[0])
    create(:fulfilled_order_item, item: @items[0], order:@inactive_order)

    @other_users.each do |user|
      orders = create_list(:shipped_order, 2, user:user)

      orders.each do |order|
        create(:fulfilled_order_item, ordered_price: 1.0, item:@other_items[2], quantity:2, order:order)
      end
    end

    @top_orders_user = create(:user, name: "C" ,state:"Utah", email:'utah@mail.com')
    @many_orders = create_list(:shipped_order, 50, user:@top_orders_user)
    @many_orders.each do |order|
      create(:fulfilled_order_item, ordered_price: 5.0, item:@items[1], quantity:10, order:order)
    end

    @other_many_orders = create_list(:shipped_order, 50, user:@top_orders_user)
    @other_many_orders.each do |order|
      create(:fulfilled_order_item, ordered_price: 10.0, item:@other_items[1], quantity:10, order:order)
    end

    @top_items_user = create(:user, name: "D")
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

    @order_1 = create(:order, user: @top_orders_user)
    @order_2 = create(:order, user: @top_items_user)
    create(:fulfilled_order_item, item:@items[0], order:@order_1)
    create(:fulfilled_order_item, item:@items[0], order:@order_2)
    create(:fulfilled_order_item, item:@items[1], order:@order_2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
  end

  context 'class methods' do
    it '.current_customers', :big_setup do
      expected = [@user_wash, @top_orders_user, @top_items_user, @utah_user]
      actual = User.current_customers(@merchant)
      expect(actual).to eq(expected)
    end

    it 'potential_customers', :big_setup  do
      expected =  [@user_oregon] + @other_users
      actual = User.potential_customers(@merchant)

      expect(actual).to eq(expected)
    end

    it '.potential_customer_info', :big_setup  do
      expected = {name: 'A', email: 'wash@mail.com', orders: 4, spent:51}
      actual = User.potential_customer_info(@user_wash, nil)

      expect(actual.name).to eq(expected[:name])
      expect(actual.email).to eq(expected[:email])
      expect(actual.num_orders).to eq(expected[:orders])
      expect(actual.spent).to eq(expected[:spent])
    end

    it '.current_customer_info', :big_setup  do
      expected = {name: 'C', email: 'utah@mail.com', merchant_revenue: 2500, total_revenue:7500}
      actual = User.current_customer_info(@top_orders_user, @merchant)

      expect(actual.name).to eq(expected[:name])
      expect(actual.email).to eq(expected[:email])
      expect(actual.merchant_revenue).to eq(expected[:merchant_revenue])
      expect(actual.total_revenue).to eq(expected[:total_revenue])
    end

    context '.to_csv(merchant = nil, potential = false)' do
      it 'not a merchant and potential:true, collects potential customer info' do
        merchants = create_list(:merchant,2)
        item_0 = create(:item, user:merchants[0])
        item_1 = create(:item, user:merchants[1])

        users_0 = create_list(:user,2)
        users_0.each_with_index do |user, index|
          orders = create_list(:shipped_order,2, user:user)
          orders.each do |order|
            create(:fulfilled_order_item, order:order, quantity:index, ordered_price:1, item:item_0)
          end
        end

        order = create(:shipped_order, user:users_0[0])
        create(:fulfilled_order_item, order:order, quantity:1, ordered_price:10, item:item_1)

        users_1 = create_list(:user,2)
        users_1.each_with_index do |user, index|
          orders = create_list(:shipped_order,2, user:user)
          orders.each do |order|
            create(:fulfilled_order_item, order:order, quantity:index+1, ordered_price:1, item:item_1)
          end
        end

        # binding.pry
        expected = "Name,Email,Orders,Spent\n"+
                   "#{users_1[0].name},#{users_1[0].email},2,2.0\n"+
                   "#{users_1[1].name},#{users_1[1].email},2,4.0\n"
        actual = User.to_csv(merchants[0], true)
        expect(actual).to eq(expected)
      end
    end
  end
  context 'instance methods' do

    it '.user_money_spent_by_merchant(merchant)', :big_setup  do
      expected = 1800
      actual = @top_items_user.user_money_spent_by_merchant(@other_merchant)
      expect(actual).to eq(expected)

      expected = 2500
      actual = @top_orders_user.user_money_spent_by_merchant(@merchant)
      expect(actual).to eq(expected)
    end

    it '.user_money_spent_total', :big_setup  do
      expected = 2800
      actual = @top_items_user.user_money_spent_total
      expect(actual).to eq(expected)

      expected = 7500
      actual = @top_orders_user.user_money_spent_total
      expect(actual).to eq(expected)
    end

    it '.total_user_orders', :big_setup  do
      expected = 100
      actual = @top_orders_user.total_user_orders

      expect(actual).to eq(expected)
    end

  end
end
