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
    where(enabled: true)
  end

  def self.sort_sold(order)
    joins(:order_items)
    .joins(:orders)
    .select("items.*, sum(order_items.quantity)as item_count")
    .where(enabled: true)
    .where("orders.status = ?", 2)
    .group(:id)
    .order("item_count #{order}")
    .limit(5)
  end

  def self.find_by_order(order, merchant)
    joins(orders: :order_items)
    .where("items.merchant_id = ?", merchant.id)
    .where("orders.id = ?", order.id)
    .distinct
  end

  def total_sold
    orders.where("orders.status = ?", 2)
               .sum('order_items.quantity') #check that order status is 'shipped' joins with orders
  end

  def fullfillment_time
    order_items.where("order_items.fulfilled = true")
               .average("order_items.updated_at - order_items.created_at")
  end

  def ordered?
    orders != []
  end

  def amount_ordered(order)
    order_items.where("order_items.order_id = ?", order.id).sum("order_items.quantity")
  end

  def fulfilled?(order)
    order_items.where("order_items.order_id = ?", order.id).first.fulfilled
  end

  def not_enough?
    if order_items.first.quantity > self.quantity
      return true
    else
      return false
    end
  end
end
