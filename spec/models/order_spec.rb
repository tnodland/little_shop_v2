require 'rails_helper'

RSpec.describe Order, type: :model do
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


         expect(@merchants.pending_orders).to eq(@orders[0..1])
       end
     end
  end

end
