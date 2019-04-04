class Item < ApplicationRecord
  validates_presence_of :name,
                        :description,
                        :image_url,
                        :quantity,
                        :current_price,
                        :merchant_id

  validates_inclusion_of :enabled, in: [true, false]

  belongs_to :user, foreign_key: 'merchant_id'
  has_many :order_items
  has_many :orders, through: :order_items

  def self.enabled_items
    where(enabled: true)
  end

  def self.sort_sold(order)
    joins(:order_items)
    .joins(:orders)
    .select("items.*, sum(distinct order_items.quantity)as item_count")
    .where(enabled: true)
    .where("orders.status = ?", 2)
    .group(:id)
    .order("item_count #{order}")
    .limit(5)
  end

  def total_sold
    orders.where("orders.status = ?", 2)
               .pluck("sum(order_items.quantity)as sold_count")
               .first
  end

  def fullfillment_time
    order_items.where("order_items.fulfilled = true")
               .average("order_items.updated_at - order_items.created_at")
  end
end
