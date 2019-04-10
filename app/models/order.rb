class Order < ApplicationRecord
  validates_presence_of :user_id, :status

  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items

  enum status: ['pending', 'packaged', 'shipped', 'cancelled']


  def initialize(args = nil)
    super(args&.except(:cart))
    add_items(args[:cart]) if args && args[:cart]
  end

  def self.from_cart(user, cart_contents)
    self.create(user: user, status: 'pending', cart: cart_contents)
  end

  def self.admin_ordered
    order("status=3, status=2, status=0, status=1", created_at: :desc)
  end

  def self.find_by_merchant(merchant)
    joins(:items).where("items.merchant_id = ?", merchant.id).distinct
  end

  def total_count
    self.order_items.sum(:quantity)
  end

  def total_cost
    self.order_items.sum("quantity*ordered_price").to_f
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
