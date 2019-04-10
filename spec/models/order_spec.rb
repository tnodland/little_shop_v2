require 'rails_helper'

RSpec.describe Order, type: :model do

  before :each do
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

  describe 'validations' do
    it {should validate_presence_of :user_id}
    it {should validate_presence_of :status}
    it {should define_enum_for :status}
  end

  describe 'relationships' do
    it {should belong_to :user}
    it {should have_many :order_items}
    it {should have_many(:items).through :order_items}
  end


  describe 'class methods' do
    it '#from_cart' do
      user = create(:user)
      item_1, item_2, item_3, item_4 = create_list(:item, 4)
      cart = {item_1.id.to_s => 1,
              item_4.id.to_s => 4,
              item_2.id.to_s => 2}
      order = Order.from_cart(user, cart)

      subject = order.order_items
      expect(subject.first.item_id).to eq(item_1.id)
      expect(subject.first.quantity).to eq(1)
      expect(subject.last.item_id).to eq(item_2.id)
      expect(subject.last.quantity).to eq(2)

      expect(subject.first.created_at).to eq(subject.first.created_at)
    end

    it ".admin_ordered gives orders from packaged, pending, shipped, and cancelled, newest to oldest" do
      OrderItem.destroy_all
      Order.destroy_all
      pending_orders = 2.times.map{ |i| create(:order, created_at:(i).minute.ago)}
      shipped_orders = 2.times.map{ |i| create(:shipped_order, created_at:(i).minute.ago)}
      cancelled_orders = 2.times.map{ |i| create(:cancelled_order, created_at:(i).minute.ago)}
      packaged_orders = 2.times.map{ |i| create(:packaged_order, created_at:(i).minute.ago)}

      desired_order =  packaged_orders + pending_orders + shipped_orders + cancelled_orders

      actual_order = Order.admin_ordered
      actual_order.zip(desired_order).each do |actual, desired|
        expect(actual.id).to eq(desired.id)
      end
    end

    it ".find_by_merchant" do
      merchant1 = create(:merchant)
      shopper = create(:user)
      merchant2 = create(:merchant)
      item1 = create(:item, user: merchant1)
      item2 = create(:item, user: merchant2)
      order = create(:order, user: shopper)
      order2 = create(:order, user: shopper)
      oi1 = create(:order_item, order: order, item: item1)
      oi2 = create(:order_item, order: order2, item: item2)

      expect(Order.find_by_merchant(merchant1)).to eq([order])
      expect(Order.find_by_merchant(merchant2)).to eq([order2])
    end

    it ".largest_orders" do
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

      expect(Order.largest_orders).to eq([order1, order2, order3])
    end
    
    it '.top_states' do
      expecteds = [{state:"Utah", orders:52},
                  {state:"Washington", orders:4},
                  {state:"Colorado", orders:1}]
      actuals = Order.top_states(@merchant)

      actuals.zip(expecteds).each do |actual, expected|
        expect(actual.state).to eq(expected[:state])
        expect(actual.order_count).to eq(expected[:orders])
      end
    end

    it '.top_cities' do
      expecteds = [{city: "Testville", state:"Utah", orders:50},
                  {city: "Seattle", state:"Washington", orders:4},
                  {city: "nothere", state:"Utah", orders:2}]
      actuals = Order.top_cities(@merchant)

      actuals.zip(expecteds).each do |actual, expected|
        expect(actual.city).to eq(expected[:city])
        expect(actual.state).to eq(expected[:state])
        expect(actual.order_count).to eq(expected[:orders])
      end
    end

    it '.top_user_orders' do
      actual = Order.top_user_orders(@merchant)
      expect(actual.name).to eq(@top_orders_user.name)
      expect(actual.order_count).to eq(50)
    end

    it '.top_user_items' do
      actual = Order.top_user_items(@merchant)
      expect(actual.name).to eq(@top_items_user.name)
      expect(actual.item_count).to eq(900)
    end

    it '.top_users_money' do
      expecteds = [{name: @top_orders_user.name, revenue: 2500.00},
                   {name: @top_items_user.name, revenue: 900.00},
                   {name: @user_wash.name, revenue: 34.00}]

      actuals = Order.top_users_money(@merchant)

      actuals.zip(expecteds).each do |actual, expected|
        expect(actual.name).to eq(expected[:name])
        expect(actual.revenue).to eq(expected[:revenue])
      end
    end
  end

  describe 'instance methods' do
    describe '.total_count' do
      it 'totals the items of a particular order' do
        order = create(:order)
        item = create(:item)
        create(:order_item, quantity: 5, ordered_price: 5.0, order: order, item: item)
        create(:order_item, quantity: 5, ordered_price: 5.0, order: order, item: item)
        create(:order_item, quantity: 5, ordered_price: 5.0, order: order, item: item)

        expect(order.total_count).to eq(15)
      end
    end

    describe '.total_cost' do
      it 'totals the cost of all items in the order' do
        order = create(:order)
        item = create(:item)
        create(:order_item, quantity: 5, ordered_price: 5.0, order: order, item: item)
        create(:order_item, quantity: 5, ordered_price: 5.0, order: order, item: item)
        create(:order_item, quantity: 5, ordered_price: 5.0, order: order, item: item)

        expect(order.total_cost).to eq(75.0)
      end
    end

    describe '.all_fulfilled?' do
      it 'checks to see if all order_items have been fulfilled' do
        order = create(:order)
        item1 = create(:item)
        item2 = create(:item)
        oi1 = create(:order_item, item: item1, order: order, fulfilled: true)
        oi2 = create(:order_item, item: item2, order: order)

        expect(order.all_fulfilled?).to eq(false)

        oi2.fulfilled = true
        oi2.save

        expect(order.all_fulfilled?).to eq(true)
      end
    end
  end

end
