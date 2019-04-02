require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'validations' do
    it {should validate_presence_of :order_id}
    it {should validate_presence_of :item_id}
    it {should validate_presence_of :quantity}
    it {should validate_presence_of :ordered_price}
    it {should validate_inclusion_of(:fulfilled).in_array([true,false])}
  end

  describe 'relationships' do
    it {should belong_to :item}
    it {should belong_to :order}
  end
end
