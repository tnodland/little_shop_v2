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
  end
end
