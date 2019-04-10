require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    @user = create(:user)
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)
    @merchant3 = create(:merchant)
    @im = create(:inactive_merchant)
    @admin = create(:admin)

    @merchant = create(:merchant)
    @items = create_list(:item, 10,  user: @merchant, quantity: 8)

    @user_wash = create(:user, name:"user_wash", state:"Washington", city:"Seattle")
    @user_2 = create(:user, name: "user_oregon", state:"Oregon")
    @utah_user = create(:user, name: "user_utah", state:"Utah", city: "nothere")

    @top_orders_user = create(:user, name:"top_orders_user", state:"Utah")
    @many_orders = create_list(:shipped_order, 50, user:@top_orders_user)
    @many_orders.each do |order|
      create(:fulfilled_order_item, ordered_price: 5.0, item:@items[1], quantity:10, order:order)
    end

    @top_items_user = create(:user, name: "top_items_user")
    @big_order = create(:shipped_order, user: @top_items_user)
    create(:fulfilled_order_item, ordered_price: 1.0, item:@items[0], quantity:900, order:@big_order)

    @shipped_orders_utah = create_list(:shipped_order,2, user: @utah_user)
    create(:fulfilled_order_item, ordered_price: 0.1, quantity: 10, item:@items[9], order:@shipped_orders_utah[0])
    create(:fulfilled_order_item, ordered_price: 0.1, quantity: 10, item:@items[9], order:@shipped_orders_utah[1])

    @shipped_orders_user_wash = create_list(:shipped_order,4, user: @user_wash)
    create(:fulfilled_order_item, ordered_price: 2.0, quantity: 4, item:@items[2], order:@shipped_orders_user_wash[0])
    create(:fulfilled_order_item, ordered_price: 2.0, quantity: 3, item:@items[3], order:@shipped_orders_user_wash[1])
    create(:fulfilled_order_item, ordered_price: 2.0, quantity: 9, item:@items[9], order:@shipped_orders_user_wash[2])
    create(:fulfilled_order_item, ordered_price: 2.0, quantity: 1, item:@items[8], order:@shipped_orders_user_wash[3])

    @order_1 = create(:order, user: @user_wash)
    @order_2 = create(:order, user: @user_2)
    create(:fulfilled_order_item, item:@items[0], order:@order_1)
    create(:fulfilled_order_item, item:@items[0], order:@order_2)
    create(:fulfilled_order_item, item:@items[1], order:@order_2)
  end

  describe 'instance methods' do
    it ".merchant_orders" do
      merchant1 = create(:merchant)
      shopper = create(:user)
      merchant2 = create(:merchant)
      item1 = create(:item, user: merchant1)
      item2 = create(:item, user: merchant2)
      order = create(:order, user: shopper)
      order2 = create(:order, user: shopper)
      oi1 = create(:order_item, order: order, item: item1)
      oi2 = create(:order_item, order: order2, item: item2)

      expect(merchant1.merchant_orders[0].id).to eq(order.id)
      expect(merchant2.merchant_orders[0].id).to eq(order2.id)
    end

    it '.top_states' do
      expecteds = [{state:"Utah", orders:52},
                  {state:"Washington", orders:4},
                  {state:"Colorado", orders:1}]
      actuals = @merchant.top_states
      binding.pry
      actuals.zip(expecteds).each do |actual, expected|
        expect(actual.state).to eq(expected[:state])
        expect(actual.order_count).to eq(expected[:orders])
      end
    end

    it '.top_cities' do
      expecteds = [{city: "Testville", state:"Utah", orders:50},
                  {city: "Seattle", state:"Washington", orders:4},
                  {city: "nothere", state:"Utah", orders:2}]
      actuals = @merchant.top_cities

      actuals.zip(expecteds).each do |actual, expected|
        expect(actual.city).to eq(expected[:city])
        expect(actual.state).to eq(expected[:state])
        expect(actual.order_count).to eq(expected[:orders])
      end
    end

    it '.top_user_orders' do
      actual = @merchant.top_user_orders
      expect(actual.name).to eq(@top_orders_user.name)
      expect(actual.order_count).to eq(50)
    end

    it '.top_user_items' do
      actual = @merchant.top_user_items
      expect(actual.name).to eq(@top_items_user.name)
      expect(actual.item_count).to eq(900)
    end

    it '.top_users_money' do
      expecteds = [{name: @top_orders_user.name, revenue: 2500.00},
                   {name: @top_items_user.name, revenue: 900.00},
                   {name: @user_wash.name, revenue: 34.00}]

      actuals = @merchant.top_users_money

      actuals.zip(expecteds).each do |actual, expected|
        expect(actual.name).to eq(expected[:name])
        expect(actual.revenue).to eq(expected[:revenue])
      end
    end
  end

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :street_address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip_code}
    it {should validate_presence_of :email}
    it {should validate_presence_of :password}
    it {should validate_presence_of :role}
    # it {should validate_exclusion_of(:enabled).in_array([nil])}
    it {should validate_uniqueness_of :email}
    it {should define_enum_for :role}
  end

  describe 'relationships' do
    it {should have_many :items}
    it {should have_many :orders}
  end

  describe 'roles' do
    it 'can create an admin' do
      user = create(:admin)

      expect(user.role).to eq("admin")
      expect(user.admin?).to be_truthy
    end

    it 'can create a merchant' do
      user = create(:merchant)

      expect(user.role).to eq("merchant")
      expect(user.merchant?).to be_truthy
    end
    it 'can create an admin' do
      user = create(:user)

      expect(user.role).to eq("user")
      expect(user.user?).to be_truthy
    end
  end

  describe "class methods" do

    it ".active_merchants" do
      expect(User.active_merchants).to eq([@merchant1, @merchant2, @merchant3, @merchant])
    end

    it ".all_merchants" do
      expect(User.all_merchants).to eq([@merchant1, @merchant2, @merchant3, @im, @merchant])
    end
  end

  describe "instance methods" do
    describe '.pending_orders' do
      it 'retrieves all of the orders which are pending' do
        @merchants = create_list(:merchant,2)

        @users = create_list(:user, 2)
        @items = create_list(:item, 2,  user: @merchants[0])
        @other_item = create(:item, user: @merchants[1])
        @orders = create_list(:order,3)
        @shipped_order = create(:shipped_order)
        @packaged_order = create(:packaged_order)

        @order_items_1 = create(:order_item, item:@items[0], order:@orders[0])
        @order_items_2 = create(:order_item, item:@items[0], order:@orders[1])
        @order_items_3 = create(:order_item, item:@items[1], order:@orders[1])
        @order_items_4 = create(:order_item, item:@other_item, order:@orders[2])
        @order_items_5 = create(:order_item, item:@items[1], order:@shipped_order)
        @order_items_6 = create(:order_item, item:@items[1], order:@packaged_order)


        expect(@merchants[0].pending_orders).to eq(@orders[0..1].map{|o| o.id})
      end
    end
  end
end
