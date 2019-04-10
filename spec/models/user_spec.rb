require 'rails_helper'

RSpec.describe User, type: :model do
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
    before :each do
      @user = create(:user)
      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant)
      @merchant3 = create(:merchant)
      @im = create(:inactive_merchant)
      @admin = create(:admin)
    end

    it ".active_merchants" do
      expect(User.active_merchants).to eq([@merchant1, @merchant2, @merchant3])
    end

    it ".all_merchants" do
      expect(User.all_merchants).to eq([@merchant1, @merchant2, @merchant3, @im])
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

    it ".average_time" do
      merchant = create(:merchant)
      item = create(:item, user: merchant)
      shopper = create(:user)
      order = create(:shipped_order, user: shopper)
      create(:fast_fulfilled_order_item, order: order, item: item)
      create(:slow_fulfilled_order_item, order: order, item: item)

      expect(merchant.average_time).to eq(2)
    end
  end
end
