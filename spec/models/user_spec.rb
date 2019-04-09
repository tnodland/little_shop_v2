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
