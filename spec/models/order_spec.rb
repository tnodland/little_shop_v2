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
end
