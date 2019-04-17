class User < ApplicationRecord
  validates_presence_of :name,
                        :street_address,
                        :city,
                        :state,
                        :zip_code,
                        :email,
                        :role
  validates :password, presence: true, length: {minimum: 5}, on: :create
  validates :password, length: {minimum: 5}, on: :update, allow_blank: true
  validates_uniqueness_of :email

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

  def merchant_orders
    items
    .joins(:orders)
    .select("orders.*")
    .distinct
  end

  def top_items
    items
    .select("items.*, sum(order_items.quantity) AS number")
    .joins(:orders)
    .where("orders.status = 2")
    .group(:id)
    .order("number DESC")
    .limit(5)
  end

  def top_states
    items
    .select("customers.state, count(customers.state) as order_count")
    .joins(:orders)
    .joins('INNER JOIN "users" as "customers" ON "customers"."id" = "orders"."user_id"')
    .where("orders.status = 2")
    .group("customers.state")
    .order("order_count DESC")
    .limit(3)
  end

  def items_sold
    items
    .joins(:orders)
    .where("orders.status = 2")
    .sum("order_items.quantity")
  end

  def pct_sold
    inventory = items.sum(:quantity).to_f
    items_sold/(inventory+items_sold) * 100
  end

  def top_cities
    items
    .select("customers.state, customers.city, count(distinct orders.id) as order_count")
    .joins(:orders)
    .joins('INNER JOIN "users" as "customers" ON "customers"."id" = "orders"."user_id"')
    .where("orders.status = 2")
    .group("customers.state")
    .group("customers.city")
    .order("order_count DESC")
    .limit(3)
  end

  def top_user_orders
    items
    .select("customers.name, count(distinct orders.id) as order_count")
    .joins(:orders)
    .joins('INNER JOIN "users" as "customers" ON "customers"."id" = "orders"."user_id"')
    .where("orders.status = 2")
    .group("customers.name")
    .order("order_count DESC")
    .first
  end

  def top_user_items
    items
    .select("customers.name, sum(order_items.quantity) as item_count")
    .joins(:orders)
    .joins('INNER JOIN "users" as "customers" ON "customers"."id" = "orders"."user_id"')
    .where("orders.status = 2")
    .group("customers.name")
    .order("item_count DESC")
    .first
  end

  def top_users_money
    items
    .select("customers.name, sum(order_items.quantity * order_items.ordered_price) as revenue")
    .joins(:orders)
    .joins('INNER JOIN "users" as "customers" ON "customers"."id" = "orders"."user_id"')
    .where("orders.status = 2")
    .group("customers.name")
    .order("revenue DESC")
     .limit(3)
  end

  def self.top_ten_sellers_this_month
    joins(items: :order_items)
    .select('users.*, sum(order_items.quantity) AS total_sold')
    .where('order_items.fulfilled = ?', true)
    .where('extract(month from order_items.created_at) = ?', Date.today.month)
    .group(:id)
    .order('total_sold DESC')
    .limit(10)
  end

  def self.top_ten_sellers_last_month
    joins(items: :order_items)
    .select('users.*, sum(order_items.quantity) AS total_sold')
    .where('order_items.fulfilled = ?', true)
    .where('extract(month from order_items.created_at) = ?', DateTime.now.last_month.month)
    .group(:id)
    .order('total_sold DESC')
    .limit(10)
  end

  def self.top_ten_fulfillers_this_month
    joins(items: {order_items: :order})
    .select("users.*, count(order_items) as total_orders")
    .where('extract(month from order_items.created_at) = ?', Date.today.month)
    .where(role: 1)
    .where("order_items.fulfilled = true")
    .where.not("orders.status = 3")
    .group(:id)
    .order("total_orders DESC")
    .limit(10)
  end

  def self.top_ten_fulfillers_last_month
    joins(items: {order_items: :order})
    .select("users.*, count(order_items) as total_orders")
    .where('extract(month from order_items.created_at) = ?', DateTime.now.last_month.month)
    .where(role: 1)
    .where("order_items.fulfilled = true")
    .where.not("orders.status = 3")
    .group(:id)
    .order("total_orders DESC")
    .limit(10)
  end

  def self.fastest_to_city(city)
    joins("as merchants JOIN items ON items.merchant_id = merchants.id")
    .joins("JOIN order_items ON order_items.item_id = items.id")
    .joins("JOIN orders ON orders.id = order_items.order_id")
    .joins("JOIN users ON users.id = orders.user_id")
    .select("merchants.*, avg(order_items.updated_at - order_items.created_at) AS fulfillment_time")
    .where("users.city = ?", city)
    .where("merchants.enabled = true")
    .where.not("orders.status = 3")
    .group("merchants.id")
    .order("fulfillment_time ASC")
    .limit(5)
  end

  def self.fastest_to_state(state)
    joins("as merchants JOIN items ON items.merchant_id = merchants.id")
    .joins("JOIN order_items ON order_items.item_id = items.id")
    .joins("JOIN orders ON orders.id = order_items.order_id")
    .joins("JOIN users ON users.id = orders.user_id")
    .select("merchants.*, avg(order_items.updated_at - order_items.created_at) AS fulfillment_time")
    .where("users.state = ?", state)
    .where("merchants.enabled = true")
    .where.not("orders.status = 3")
    .group("merchants.id")
    .order("fulfillment_time ASC")
    .limit(5)
  end

  def self.to_current_csv(users, merchant)
    attributes = %w{name email total_spent total_spent_on_me}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      users.each do |user|
        csv << [user.name, user.email, user.total_money_spent, user.total_spent_on_merchant(merchant)]
      end
    end
  end

  def self.to_potential_csv(users, merchant)
    attributes = %w{name email total_spent total_orders_placed}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      users.each do |user|
        csv << [user.name, user.email, user.total_money_spent, user.total_orders_placed]
      end
    end
  end

  def self.find_by_shopper(merchant)
    joins(orders: {order_items: :item})
    .where("items.merchant_id = #{merchant.id}")
    .where(role: 0)
    .distinct
  end

  def self.find_by_potential(merchant)
    # binding.pry
    joins(orders: {order_items: :item})
    .where.not("items.merchant_id = #{merchant.id}")
    .where(role: 0)
    .distinct
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
    items.select("orders.id")
         .joins(:orders)
         .where(orders: {status: 0})
         .distinct
         .pluck("orders.id")
  end

  def average_time
    items.joins(:order_items)
         .average('order_items.updated_at - order_items.created_at')
  end

  def total_money_spent
    orders.joins(:order_items)
          .pluck("sum(order_items.ordered_price * order_items.quantity)")
          .first
  end

  def total_spent_on_merchant(merchant)
    orders.joins(items: :order_items)
          .where("items.merchant_id = #{merchant.id}")
          .pluck("sum(order_items.ordered_price * order_items.quantity)")
          .first
  end

  def total_orders_placed
    orders.count
  end
end
