class Item < ApplicationRecord
  validates_presence_of :name,
                        :description,
                        :image_url
  validates :quantity, presence: true, numericality:{ only_integer: true, greater_than_or_equal_to: 0}
  validates :current_price, presence: true, numericality:{ greater_than: 0}
  belongs_to :user, foreign_key: 'merchant_id'
  has_many :order_items
  has_many :orders, through: :order_items

  def self.enabled_items
    where(enabled: true, users: {enabled: true})
    .joins(:user)
    .select('items.*, users.name AS merchant_name')
  end

  def self.sort_sold(direction)
    joins(order_items: :order)
    .select("items.*, sum(order_items.quantity) as item_count")
    .where(enabled: true, orders: {status: 2})
    .group(:id)
    .order('item_count ' + direction)
    .limit(5)
  end

  def self.find_by_order(order, merchant)
    joins(order_items: :order)
    .where(items: {merchant_id: merchant.id},
          orders: {id: order.id})
    .distinct
  end

  def self.merchant_top_items(merchant)
    select("items.*, sum(order_items.quantity) AS number")
    .joins(orders: :order_items)
    .where(user:merchant)
    .where( "orders.status = ?", 2)
    .group(:id)
    .order("number DESC")
    .limit(5)
  end

  def self.items_sold(merchant)
    joins(orders: :order_items)
    .where(user:merchant)
    .where("orders.status = ?", 2)
    .sum("order_items.quantity")
  end

  def self.pct_sold(merchant)
    in_stock = Item.where(user:merchant).sum(:quantity).to_f
    ((1- (in_stock / (in_stock + items_sold(merchant))))*100).round(2)
  end

  def fullfillment_time
    order_items.where(order_items: {fulfilled: true})
               .average("order_items.updated_at - order_items.created_at")
  end

  def ordered?
    orders != []
  end

  def amount_ordered(order)
    order_items.where(order_items: {order_id: order.id})
               .sum("order_items.quantity")
  end

  def fulfilled?(order)
    order_items.where(order_items: {order_id: order.id})
               .first.fulfilled
  end

  def not_enough?
    if order_items.first.quantity > self.quantity
      return true
    else
      return false
    end
  end
end
