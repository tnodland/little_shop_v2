require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'validations' do
    # it {should validate_presence_of :order_id}
    # it {should validate_presence_of :item_id}
    it {should validate_presence_of :quantity}
    it {should validate_presence_of :ordered_price}
    # it {should validate_exclusion_of(:fulfilled).in_array([nil])}
  end

  describe 'relationships' do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe 'Instance Variables' do
    describe '.subtotal' do
      it 'totals the quantity and ordered price of an orderitem' do
        order_item = create(:order_item, quantity: 5, ordered_price: 5.0)

        expect(order_item.subtotal).to eq(25.0)
      end
    end
  end
end
