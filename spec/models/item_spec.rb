require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :image_url}
    it {should validate_presence_of :quantity}
    it {should validate_presence_of :current_price}
    it {should validate_exclusion_of(:enabled).in_array([nil])}
    it {should validate_presence_of :merchant_id}

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
  end
end
