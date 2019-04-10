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

  def self.find_by_merchant(merchant)
    joins(:items).where("items.merchant_id = ?", merchant.id).distinct
  end

  def total_count
    self.order_items.sum(:quantity)
  end

  def total_cost
    self.order_items.sum("quantity*ordered_price").to_f
  end

  def self.top_states(merchant)
    select("users.state, count(distinct orders.id) as order_count")
    .joins(:user)
    .joins(items: :order_items)
    .where("items.merchant_id = #{merchant.id}")
    .where(status: :shipped)
    .group("users.state")
    .order("order_count DESC")
    .limit(3)
  end

  def self.top_cities(merchant)
    select("users.state, count(distinct orders.id) as order_count")
    .joins(:user)
    .joins(items: :order_items)
    .where("items.merchant_id = #{merchant.id}")
    .where(status: :shipped)
    .group("users.state")
    .group("users.city")
    .order("order_count DESC")
    .limit(3)
  end

  def self.top_user_orders(merchant)
    select("users.name, count(distinct orders.id) as order_count")
    .joins(:user)
    .joins(items: :order_items)
    .where("items.merchant_id = #{merchant.id}")
    .where(status: :shipped)
    .group("users.id")
    .order("order_count DESC").first
  end

  def self.top_user_items(merchant)
    select("users.name, sum(order_items.quantity) as item_count")
    .joins(:user)
    .joins(items: :order_items)
    .where("items.merchant_id = #{merchant.id}")
    .where(status: :shipped)
    .group("users.name")
    .order("item_count DESC")
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
