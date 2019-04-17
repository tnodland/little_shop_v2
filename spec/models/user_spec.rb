require 'rails_helper'

RSpec.describe User, type: :model do
  before :each, big_setup: true do
    @user = create(:user)
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)
    @merchant3 = create(:merchant)
    @im = create(:inactive_merchant)
    @admin = create(:admin)

    @merchant = create(:merchant)
    @items = create_list(:item, 10,  user: @merchant, quantity: 200)

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
    create(:fulfilled_order_item, ordered_price: 1.0, item:@items[0], quantity:1463, order:@big_order)

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
    it ".top_merchant_items" , :big_setup do

      top_items_actual = @merchant.top_items
      top_items_expected = [@items[0], @items[1], @items[9], @items[2], @items[3]]

      top_items_actual.zip(top_items_expected).each do |actual, expected|
        expect(actual.id).to eq(expected.id)
      end

    end

    it '.items_sold', :big_setup  do
      expect(@merchant.items_sold).to eq(2000)
    end

    it '.pct_sold', :big_setup  do
      expect(@merchant.pct_sold).to eq(50.0)
    end

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

    it '.top_states', :big_setup  do
      expecteds = [{state:"Utah", orders:52},
                  {state:"Washington", orders:4},
                  {state:"Colorado", orders:1}]
      actuals = @merchant.top_states
      actuals.zip(expecteds).each do |actual, expected|
        expect(actual.state).to eq(expected[:state])
        expect(actual.order_count).to eq(expected[:orders])
      end
    end

    it '.top_cities', :big_setup  do
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

    it '.top_user_orders', :big_setup  do
      actual = @merchant.top_user_orders
      expect(actual.name).to eq(@top_orders_user.name)
      expect(actual.order_count).to eq(50)
    end

    it '.top_user_items', :big_setup  do
      actual = @merchant.top_user_items
      expect(actual.name).to eq(@top_items_user.name)
      expect(actual.item_count).to eq(1463)
    end

    it '.top_users_money', :big_setup  do
      expecteds = [{name: @top_orders_user.name, revenue: 2500.00},
                   {name: @top_items_user.name, revenue: 1463.00},
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
    it ".top_ten_sellers_this_month" do
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

      expect(User.top_ten_sellers_this_month).to eq([merchant1, merchant2, merchant3, merchant4, merchant5, merchant6, merchant7, merchant8, merchant9, merchant10])
    end

    it ".top_ten_sellers_last_month" do
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

      expect(User.top_ten_sellers_last_month).to eq([merchant1, merchant2, merchant3, merchant4, merchant5, merchant6, merchant7, merchant8, merchant9, merchant10])
    end

    it ".top_ten_fulfillers_this_month" do
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

      expect(User.top_ten_fulfillers_this_month).to eq([merchant1, merchant2, merchant3, merchant4, merchant5, merchant6, merchant7, merchant8, merchant9, merchant10])
    end

    it ".top_ten_fulfillers_last_month" do
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

      expect(User.top_ten_fulfillers_last_month).to eq([merchant1, merchant2, merchant3, merchant4, merchant5, merchant6, merchant7, merchant8, merchant9, merchant10])
    end

    it ".find_by_shopper and .find_by_potential" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)
      merchant4 = create(:merchant)
      shopper1 = create(:user)
      shopper2 = create(:user)
      shopper3 = create(:user)
      item1 = create(:item, user: merchant1, quantity: 20)
      item2 = create(:item, user: merchant2, quantity: 20)
      item3 = create(:item, user: merchant3, quantity: 50)
      item4 = create(:item, user: merchant4, quantity: 50)
      order1 = create(:shipped_order, user: shopper1)
      order2 = create(:shipped_order, user: shopper2)
      order3 = create(:shipped_order, user: shopper3)
      create(:fulfilled_order_item, item: item1, order: order1)
      create(:fulfilled_order_item, item: item1, order: order2)
      create(:fulfilled_order_item, item: item2, order: order3)
      create(:fulfilled_order_item, item: item3, order: order1)
      create(:fulfilled_order_item, item: item3, order: order2)
      create(:fulfilled_order_item, item: item3, order: order3)

      expect(User.find_by_shopper(merchant1)).to eq([shopper1, shopper2])
      expect(User.find_by_shopper(merchant2)).to eq([shopper3])
      # binding.pry
      expect(User.find_by_shopper(merchant3)).to eq([shopper1, shopper2, shopper3])
      expect(User.find_by_shopper(merchant4)).to eq([])
      expect(User.find_by_potential(merchant1)).to eq([shopper3])
      expect(User.find_by_potential(merchant2)).to eq([shopper1, shopper2])
      expect(User.find_by_potential(merchant3)).to eq([])
    end

    it ".fastest_to_city and .fastest_to_state" do
      shopper = create(:user)
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)
      merchant4 = create(:merchant)
      merchant5 = create(:merchant)
      merchant6 = create(:merchant)

      item1 = create(:item, user: merchant1, quantity: 100)
      item2 = create(:item, user: merchant2, quantity: 100)
      item3 = create(:item, user: merchant3, quantity: 100)
      item4 = create(:item, user: merchant4, quantity: 100)
      item5 = create(:item, user: merchant5, quantity: 100)
      item6 = create(:item, user: merchant6, quantity: 100)

      order = create(:shipped_order, user: shopper)

      create_list(:fast_fulfilled_order_item, 4, item: item1, order: order)
      create_list(:fast_fulfilled_order_item, 3, item: item2, order: order)
      create(:slow_fulfilled_order_item, item: item2, order: order)
      create_list(:fast_fulfilled_order_item, 2, item: item3, order: order)
      create_list(:slow_fulfilled_order_item, 2, item: item3, order: order)
      create(:fast_fulfilled_order_item, item: item4, order: order)
      create_list(:slow_fulfilled_order_item, 3, item: item4, order: order)
      create_list(:slow_fulfilled_order_item, 4, item: item5, order: order)
      create(:fast_fulfilled_order_item, item: item5, order: order)
      create_list(:slow_fulfilled_order_item, 5, item: item6, order: order)

      expect(User.fastest_to_city(shopper.city)).to eq([merchant1, merchant2, merchant3, merchant4, merchant5])
      expect(User.fastest_to_state(shopper.state)).to eq([merchant1, merchant2, merchant3, merchant4, merchant5])
    end

    it ".active_merchants", :big_setup  do
      expect(User.active_merchants).to eq([@merchant1, @merchant2, @merchant3, @merchant])
    end

    it ".all_merchants", :big_setup  do
      expect(User.all_merchants).to eq([@merchant1, @merchant2, @merchant3, @im, @merchant])
    end

    it ".top_three_sellers" do
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

      expect(User.top_three_sellers).to eq([merchant4, merchant3, merchant2])
    end

    it ".sort_by_fulfillment" do
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
      create(:fast_fulfilled_order_item, order: order, item: item1, quantity: 10)
      create(:fast_fulfilled_order_item, order: order, item: item1, quantity: 10)
      create(:fast_fulfilled_order_item, order: order, item: item1, quantity: 10)
      create(:fast_fulfilled_order_item, order: order, item: item2, quantity: 20)
      create(:fast_fulfilled_order_item, order: order, item: item2, quantity: 20)
      create(:slow_fulfilled_order_item, order: order, item: item2, quantity: 20)
      create(:fast_fulfilled_order_item, order: order, item: item3, quantity: 30)
      create(:slow_fulfilled_order_item, order: order, item: item3, quantity: 30)
      create(:slow_fulfilled_order_item, order: order, item: item3, quantity: 30)
      create(:slow_fulfilled_order_item, order: order, item: item4, quantity: 40)
      create(:slow_fulfilled_order_item, order: order, item: item4, quantity: 40)
      create(:slow_fulfilled_order_item, order: order, item: item4, quantity: 40)

      expect(User.sort_by_fulfillment("desc")).to eq([merchant4, merchant3, merchant2])
      expect(User.sort_by_fulfillment("asc")).to eq([merchant1, merchant2, merchant3])
    end

    it ".top_three_cities and .top_three_states" do
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

      expect(User.top_three_cities[0].city).to eq("Denver")
      expect(User.top_three_cities[0].count_of_orders).to eq(4)
      expect(User.top_three_cities[1].city).to eq("St Paul")
      expect(User.top_three_cities[1].count_of_orders).to eq(3)
      expect(User.top_three_cities[2].city).to eq("Las Vegas")
      expect(User.top_three_cities[2].count_of_orders).to eq(2)

      expect(User.top_three_states[0].state).to eq("Colorado")
      expect(User.top_three_states[0].count_of_orders).to eq(4)
      expect(User.top_three_states[1].state).to eq("Minnesota")
      expect(User.top_three_states[1].count_of_orders).to eq(3)
      expect(User.top_three_states[2].state).to eq("Nevada")
      expect(User.top_three_states[2].count_of_orders).to eq(2)
    end
  end

  describe "instance methods" do
    describe '.pending_orders' do
      it 'retrieves all of the orders which are pending' do
        merchants = create_list(:merchant,2)

        users = create_list(:user, 2)
        items = create_list(:item, 2,  user: merchants[0])
        other_item = create(:item, user: merchants[1])
        orders = create_list(:order,3)
        shipped_order = create(:shipped_order)
        packaged_order = create(:packaged_order)

        order_items_1 = create(:order_item, item:items[0], order:orders[0])
        order_items_2 = create(:order_item, item:items[0], order:orders[1])
        order_items_3 = create(:order_item, item:items[1], order:orders[1])
        order_items_4 = create(:order_item, item:other_item, order:orders[2])
        order_items_5 = create(:order_item, item:items[1], order:shipped_order)
        order_items_6 = create(:order_item, item:items[1], order:packaged_order)


        expect(merchants[0].pending_orders).to eq(orders[0..1].map{|o| o.id})
      end
    end

    it ".average_time" do
      merchant = create(:merchant)
      item = create(:item, user: merchant)
      shopper = create(:user)
      order = create(:shipped_order, user: shopper)
      create(:fast_fulfilled_order_item, order: order, item: item)
      create(:slow_fulfilled_order_item, order: order, item: item)

      expect(merchant.average_time).to eq(2)
    end

    it ".total_money_spent" do
      merchant = create(:merchant)
      item = create(:item, user: merchant)
      shopper = create(:user)
      order = create(:shipped_order, user: shopper)
      create(:fulfilled_order_item, item: item, order: order, ordered_price: 2.5, quantity: 2)
      create(:fulfilled_order_item, item: item, order: order, ordered_price: 2.5, quantity: 3)

      expect(shopper.total_money_spent).to eq(12.5)
    end

    it ".total_spent_on_merchant" do
      merchant = create(:merchant)
      merchant2 = create(:merchant)
      item = create(:item, user: merchant)
      item2 = create(:item, user: merchant2)
      shopper = create(:user)
      order = create(:shipped_order, user: shopper)
      create(:fulfilled_order_item, item: item, order: order, ordered_price: 2.5, quantity: 2)
      create(:fulfilled_order_item, item: item2, order: order, ordered_price: 2.5, quantity: 3)

      expect(shopper.total_spent_on_merchant(merchant)).to eq(5)
      expect(shopper.total_spent_on_merchant(merchant2)).to eq(7.5)
    end

    it ".total_orders_placed" do
      shopper1 = create(:user)
      shopper2 = create(:user)
      merchant = create(:merchant)
      item = create(:item, user: merchant, quantity: 100)

      order1 = create(:shipped_order, user: shopper1)
      order2 = create(:shipped_order, user: shopper2)
      order3 = create(:shipped_order, user: shopper1)

      create(:fulfilled_order_item, item: item, order: order1)
      create(:fulfilled_order_item, item: item, order: order2)
      create(:fulfilled_order_item, item: item, order: order3)

      expect(shopper1.total_orders_placed).to eq(2)
      expect(shopper2.total_orders_placed).to eq(1)
    end
  end
end
