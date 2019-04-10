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
    joins(items: :order_items)
    .select('users.*, sum(order_items.quantity * order_items.ordered_price) AS total_revenue')
    .group(:id)
    .order('total_revenue DESC')
    .limit(3)
  end

  def self.sort_by_fulfillment(order)
    joins(items: :order_items)
    .where('order_items.fulfilled = ?', true)
    .group(:id).select('users.*, avg(order_items.updated_at - order_items.created_at) AS fulfillment_time')
    .order("fulfillment_time #{order}")
    .limit(3)
  end

  def self.top_three_cities
    joins(:orders)
    .select('users.city, count(orders.id) AS count_of_orders')
    .group('users.city')
    .where('orders.status = 2')
    .order('count_of_orders DESC')
    .limit(3)
  end

  def self.top_three_states
    joins(:orders)
    .select('users.state, count(orders.id) AS count_of_orders')
    .group('users.state')
    .where('orders.status = 2')
    .order('count_of_orders DESC')
    .limit(3)
  end

  def pending_orders
    items.select("orders.id").joins(:orders).where("orders.status": 0).distinct.pluck("orders.id")
  end

  def average_time
    items.joins(:order_items)
         .average('order_items.updated_at - order_items.created_at')
  end
end
