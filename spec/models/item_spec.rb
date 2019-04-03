require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :image_url}
    it {should validate_presence_of :quantity}
    it {should validate_presence_of :current_price}
    # it {should validate_exclusion_of(:enabled).in_array([nil])}
    # it {should validate_presence_of :merchant_id}

  end

  describe 'relationships' do
    it {should belong_to :user}
    it {should have_many :order_items}
    it {should have_many(:orders).through :order_items}
  end

  describe 'class methods' do
    it ".enabled_items" do
      merchant  = create(:merchant)
      item1 = create(:item, user: merchant)
      item2 = create(:item, user: merchant)
      item3 = create(:inactive_item, user: merchant)

      expect(Item.enabled_items).to eq([item1, item2])
    end

    it ".sort_sold" do
      merchant  = create(:merchant)
      item1 = create(:item, user: merchant)
      item2 = create(:item, user: merchant)
      item3 = create(:item, user: merchant)
      item4 = create(:item, user: merchant)
      item5 = create(:item, user: merchant)

      shopper = create(:user)
      order = create(:shipped_order, user: shopper)

      create(:fulfilled_order_item, order: order, item: item1, quantity: item1.quantity)
      create(:fulfilled_order_item, order: order, item: item2, quantity: item2.quantity)
      create(:fulfilled_order_item, order: order, item: item3, quantity: item3.quantity)
      create(:fulfilled_order_item, order: order, item: item4, quantity: item4.quantity)
      create(:fulfilled_order_item, order: order, item: item5, quantity: item5.quantity)

      expect(Item.sort_sold("ASC")).to eq([item1, item2, item3, item4, item5])
      expect(Item.sort_sold("DESC")).to eq([item5, item4, item3, item2, item1])
    end
  end

  describe 'instance methods' do
    it ".total_sold" do
      merchant  = create(:merchant)
      item1 = create(:item, user: merchant, quantity: 100)
      shopper = create(:user)
      order = create(:order, user: shopper)
      create(:fulfilled_order_item, order: order, item: item1, quantity: 10)
      create(:fulfilled_order_item, order: order, item: item1, quantity: 5)
      create(:order_item, order: order, item: item1, quantity: 5)

      expect(item1.total_sold).to eq(15)
    end
  end
end
