require 'rails_helper'

RSpec.describe Item, type: :model do

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :image_url}
    it {should validate_presence_of :quantity}
    it {should validate_presence_of :current_price}
  end

  describe 'relationships' do
    it {should belong_to :user}
    it {should have_many :order_items}
    it {should have_many(:orders).through :order_items}
  end

  describe 'class methods' do
    it ".top_merchant_items" do
      merchant = create(:merchant)
      items = create_list(:item, 10,  user: merchant, quantity: 8)

      user_wash = create(:user, state:"Washington", city:"Seattle")
      user_2 = create(:user, state:"Oregon")
      utah_user = create(:user, state:"Utah", city: "nothere")

      top_orders_user = create(:user, state:"Utah")
      many_orders = create_list(:shipped_order, 50, user:top_orders_user)
      many_orders.each do |order|
        create(:fulfilled_order_item, item:items[1], quantity:10, order:order)
      end

      top_items_user = create(:user)
      big_order = create(:shipped_order, user: top_items_user)
      create(:fulfilled_order_item, item:items[0], quantity:1000, order:big_order)

      shipped_order_utah = create(:shipped_order, user: utah_user)
      order_items_7 = create(:fulfilled_order_item, ordered_price: 0.1, quantity: 83, item:items[9], order:shipped_order_utah)

      shipped_orders_user_wash = create_list(:shipped_order,2, user: user_wash)
      order_items_4 = create(:fulfilled_order_item, ordered_price: 3.0, quantity: 4, item:items[2], order:shipped_orders_user_wash[0])
      order_items_5 = create(:fulfilled_order_item, ordered_price: 3.0, quantity: 3, item:items[3], order:shipped_orders_user_wash[1])
      order_items_6 = create(:fulfilled_order_item, ordered_price: 3.0, quantity: 9, item:items[9], order:shipped_orders_user_wash[0])
      order_items_6 = create(:fulfilled_order_item, ordered_price: 3.0, quantity: 1, item:items[8], order:shipped_orders_user_wash[1])

      order_1 = create(:order, user: user_wash)
      order_2 = create(:order, user: user_2)
      order_items_1 = create(:fulfilled_order_item, item:items[0], order:order_1)
      order_items_2 = create(:fulfilled_order_item, item:items[0], order:order_2)
      order_items_3 = create(:fulfilled_order_item, item:items[1], order:order_2)

      top_items_actual = Item.merchant_top_items(merchant)
      top_items_expected = [items[0], items[1], items[9], items[2], items[3]]

      top_items_actual.zip(top_items_expected).each do |actual, expected|
        expect(actual.id).to eq(expected.id)
      end

    end

    it '.items_sold' do
      merchant = create(:merchant)
      items = create_list(:item, 10,  user: merchant, quantity: 8)

      user_wash = create(:user, name:"user_wash", state:"Washington", city:"Seattle")
      user_2 = create(:user, name: "user_oregon", state:"Oregon")
      utah_user = create(:user, name: "user_utah", state:"Utah", city: "nothere")

      top_orders_user = create(:user, name:"top_orders_user", state:"Utah")
      many_orders = create_list(:shipped_order, 50, user:top_orders_user)
      many_orders.each do |order|
        create(:fulfilled_order_item, ordered_price: 5.0, item:items[1], quantity:10, order:order)
      end

      top_items_user = create(:user, name: "top_items_user")
      big_order = create(:shipped_order, user: top_items_user)
      create(:fulfilled_order_item, ordered_price: 1.0, item:items[0], quantity:900, order:big_order)

      shipped_orders_utah = create_list(:shipped_order,2, user: utah_user)
      create(:fulfilled_order_item, ordered_price: 0.1, quantity: 10, item:items[9], order:shipped_orders_utah[0])
      create(:fulfilled_order_item, ordered_price: 0.1, quantity: 10, item:items[9], order:shipped_orders_utah[1])

      shipped_orders_user_wash = create_list(:shipped_order,4, user: user_wash)
      create(:fulfilled_order_item, ordered_price: 2.0, quantity: 4, item:items[2], order:shipped_orders_user_wash[0])
      create(:fulfilled_order_item, ordered_price: 2.0, quantity: 3, item:items[3], order:shipped_orders_user_wash[1])
      create(:fulfilled_order_item, ordered_price: 2.0, quantity: 9, item:items[9], order:shipped_orders_user_wash[2])
      create(:fulfilled_order_item, ordered_price: 2.0, quantity: 1, item:items[8], order:shipped_orders_user_wash[3])

      order_1 = create(:order, user: user_wash)
      order_2 = create(:order, user: user_2)
      create(:fulfilled_order_item, item:items[0], order:order_1)
      create(:fulfilled_order_item, item:items[0], order:order_2)
      create(:fulfilled_order_item, item:items[1], order:order_2)

      expect(Item.items_sold(merchant)).to eq(1437)
    end

    it '.pct_sold' do
      merchant = create(:merchant)
      items = create_list(:item, 10,  user: merchant, quantity: 15)

      user_wash = create(:user, name:"user_wash", state:"Washington", city:"Seattle")
      user_2 = create(:user, name: "user_oregon", state:"Oregon")
      utah_user = create(:user, name: "user_utah", state:"Utah", city: "nothere")

      top_orders_user = create(:user, name:"top_orders_user", state:"Utah")
      many_orders = create_list(:shipped_order, 50, user:top_orders_user)
      many_orders.each do |order|
        create(:fulfilled_order_item, ordered_price: 5.0, item:items[1], quantity:10, order:order)
      end

      top_items_user = create(:user, name: "top_items_user")
      big_order = create(:shipped_order, user: top_items_user)
      create(:fulfilled_order_item, ordered_price: 1.0, item:items[0], quantity:850, order:big_order)

      order_1 = create(:order, user: user_wash)
      order_2 = create(:order, user: user_2)
      create(:fulfilled_order_item, item:items[0], order:order_1)
      create(:fulfilled_order_item, item:items[0], order:order_2)
      create(:fulfilled_order_item, item:items[1], order:order_2)

      expect(Item.pct_sold(merchant)).to eq(90.0)
    end

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

    it ".find_by_order" do
      merchant1 = create(:merchant)
      shopper = create(:user)
      merchant2 = create(:merchant)
      item1 = create(:item, user: merchant1)
      item2 = create(:item, user: merchant2)
      item3 = create(:item, user: merchant1)

      order = create(:order, user: shopper)
      oi1 = create(:order_item, order: order, item: item1)
      oi2 = create(:order_item, order: order, item: item2)
      oi3 = create(:order_item, order: order, item: item3)

      expect(Item.find_by_order(order, merchant1)).to eq([item1, item3])
    end
  end

  describe 'instance methods' do
    before :each do
      @merchant  = create(:merchant)
      @item1 = create(:item, user: @merchant, quantity: 100)
      @item2 = create(:item, user: @merchant, quantity: 100)
      @shopper = create(:user)
      @order = create(:fast_shipped_order, user: @shopper)
      @order2 = create(:order, user: @shopper)

      create(:fast_fulfilled_order_item, order: @order, item: @item1, quantity: 10, created_at: "Wed, 03 Apr 2019 14:11:25 UTC +00:00", updated_at: "Thu, 04 Apr 2019 14:11:25 UTC +00:00")
      create(:fast_fulfilled_order_item, order: @order, item: @item1, quantity: 5, created_at: "Wed, 03 Apr 2019 14:11:25 UTC +00:00", updated_at: "Thu, 04 Apr 2019 14:11:25 UTC +00:00")
      create(:order_item, order: @order2, item: @item1, quantity: 5)
      create(:fast_fulfilled_order_item, order: @order2, item: @item2, quantity: 7, created_at: "Mon, 01 Apr 2019 14:11:25 UTC +00:00", updated_at: "Thu, 04 Apr 2019 14:11:25 UTC +00:00")
    end

    it ".fullfillment_time" do
      expect(@item1.fullfillment_time).to eq(1)
    end

    it '.ordered?' do
      item3 = create(:item)

      expect(item3.ordered?).to eq(false)
      expect(@item2.ordered?).to eq(true)
    end

    it ".amount_ordered" do
      expect(@item2.amount_ordered(@order2)).to eq(7)
    end

    it ".fulfilled?" do
      expect(@item1.fulfilled?(@order)).to eq(true)
      expect(@item1.fulfilled?(@order2)).to eq(false)
    end

    it ".not_enough?" do
      item = create(:item, quantity: 1, user: @merchant)
      item2 = create(:item, quantity: 10, user: @merchant)
      order4 = create(:order, user: @shopper)
      oi4 = create(:order_item, order: order4, item: item, quantity: 10)
      oi5 = create(:order_item, order: order4, item: item2, quantity: 10)

      expect(item.not_enough?).to eq(true)
      expect(item2.not_enough?).to eq(false)
    end
  end
end
