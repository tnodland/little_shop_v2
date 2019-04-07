class Order < ApplicationRecord
  validates_presence_of :user_id, :status

  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items

  enum status: ['pending', 'packaged', 'shipped', 'cancelled']

  def initialize(attributes = nil)
    super(attributes.except(:cart))
    add_items(attributes[:cart]) if attributes[:cart]
  end

  def self.from_cart(user, cart)
    self.create(user: user, status: 'pending', cart: cart)
  end

  private

  def add_items(cart)
    cart.each do |item_id, quantity|
      item = Item.find(item_id)
      self.order_items.new(item_id: item_id,
                          quantity: quantity,
                     ordered_price: item.current_price,
                        created_at: self.created_at)
    end
  end
end
