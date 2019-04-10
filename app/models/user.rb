class User < ApplicationRecord
  validates_presence_of :name,
                        :street_address,
                        :city,
                        :state,
                        :zip_code,
                        :email,
                        :role

  # validates_presence_of :password, require: true
  validates :password, presence: true, length: {minimum: 5, maximum: 120}, on: :create
  validates :password, length: {minimum: 5, maximum: 120}, on: :update, allow_blank: true
  validates_uniqueness_of :email

  # validates_exclusion_of :enabled, in: [nil]

  has_many :orders
  has_many :items, foreign_key: "merchant_id"

  enum role: ['user', 'merchant', 'admin']

  has_secure_password

  def self.active_merchants
    User.where(role: 1)
        .where(enabled: true)
  end

  def self.all_merchants
    User.where(role: 1)
  end

  def self.top_three_sellers
    joins(items: [{order_items: :order}]).order('order_items.ordered_price'.to_i * 'order_items.quantity'.to_i, :asc).group(:id).limit(3)
  end

  def self.sort_by_fulfillment(order)
    joins(items: :order_items)
    .where('order_items.fulfilled = ?', true)
    .group(:id).select('users.*, avg(order_items.updated_at - order_items.created_at) AS fulfillment_time')
    .order("fulfillment_time #{order}")
    .limit(3)
  end

  def pending_orders
    items.select("orders.id").joins(:orders).where("orders.status": 0).distinct.pluck("orders.id")
  end

  def total_revenue
    binding.pry
    Item.joins(:order_items).where("items.merchant_id = ?", self.id)
  end

  def average_time
    items.joins(:order_items)
         .average('order_items.updated_at - order_items.created_at')
  end
end
