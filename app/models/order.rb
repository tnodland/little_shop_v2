class Order < ApplicationRecord
  validates_presence_of :user_id, :status

  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items

  enum status: ['pending', 'packaged', 'shipped', 'cancelled']

  def self.from_cart(user, cart)
    fresh_order = self.create(user: user, status: 'pending')
    cart.each do |item_id, quantity|
      item = Item.find(item_id)
      fresh_order.order_items.create(item_id: item_id,
                                    quantity: quantity,
                               ordered_price: item.current_price,
                                  created_at: fresh_order.created_at)
    end
    return fresh_order
  end
end
