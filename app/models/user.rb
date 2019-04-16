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

  def user_money_spent_total
    orders
    .where("orders.status = 2") # order shipped
    .joins(:order_items)
    .sum("order_items.quantity * order_items.ordered_price")
  end

  def user_money_spent_by_merchant(merchant)
    orders
    .where("orders.status = 2")
    .joins(:order_items)
    .joins(:items)
    .where("items.merchant_id = ?", merchant.id)
    .sum("order_items.quantity * order_items.ordered_price")
  end

  def total_user_orders
    orders
    .where("orders.status = 2")
    .count
  end

  def self.to_csv(merchant, potential = false)
    case potential
      when true
      customers = potential_customers(merchant)
      info_method = :potential_customer_info
      columns = ["name", "email", "num_orders", "spent"]
      headers = ["Name", "Email", "Orders", "Spent"]
      when false
      customers = current_customers(merchant)
      info_method = :current_customer_info
      columns = ["name", "email", "merchant_revenue", "total_revenue"]
      headers = ["Name", "Email", "Merchant Revenue", "Total Revenue"]
    end

    CSV.generate do |csv|
      csv << headers
      customers.each do |customer|
        info = send info_method, customer, merchant
        csv << info.attributes.values_at(*columns)
      end
    end
  end

  def self.current_customers(merchant)
    joins('INNER JOIN "orders" ON "orders"."user_id" = "users"."id"')
    .joins('INNER JOIN "order_items" ON "order_items"."order_id" = "orders"."id"')
    .joins('INNER JOIN "items" ON "items"."id" = "order_items"."item_id"')
    .where('items.merchant_id = ?', merchant.id)
    .where("orders.status = 2")
    .where(enabled: true)
    .select('DISTINCT users.*')
    .order('users.name ASC')
  end

  def self.potential_customers(merchant)
    with_order = joins('INNER JOIN "orders" ON "orders"."user_id" = "users"."id"')
    .joins('INNER JOIN "order_items" ON "order_items"."order_id" = "orders"."id"')
    .joins('INNER JOIN "items" ON "items"."id" = "order_items"."item_id"')
    .group("users.id")
    .where("orders.status = 2")
    .where(enabled: true)
    .select("users.*")
    .having("COUNT(case when items.merchant_id = #{merchant.id} then 1 else null end) = 0")

    no_orders = left_outer_joins(:orders).where(role: :user).where("orders.id IS NULL").where(enabled: true)
    all_potential = with_order + no_orders
    all_potential.sort_by{ |user| user.name}
  end

  def self.potential_customer_info(user, merchant)
    joins(:orders)
    .joins('INNER JOIN "order_items" ON "order_items"."order_id" = "orders"."id"')
    .where("orders.status = 2")
    .where(id: user.id)
    .select("users.name, users.email, COUNT(DISTINCT orders.id) AS num_orders, SUM(order_items.quantity * order_items.ordered_price) AS spent")
    .group(:id).first
  end

  def self.current_customer_info(user, merchant)
    joins('INNER JOIN "orders" ON "orders"."user_id" = "users"."id"')
    .joins('INNER JOIN "order_items" ON "order_items"."order_id" = "orders"."id"')
    .joins('INNER JOIN "items" ON "items"."id" = "order_items"."item_id"')
    .where("orders.status = 2")
    .where("users.id = #{user.id}")
    .group("users.id")
    .select("users.name")
    .select("users.email")
    .select("SUM(order_items.quantity * order_items.ordered_price) AS total_revenue")
    .select("SUM(CASE WHEN items.merchant_id = #{merchant.id} THEN (order_items.quantity * order_items.ordered_price) ELSE null END) AS merchant_revenue")
    .first
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

  def percent_sold_data_for_graphic
    [{'label'=> 'Sold', 'value'=>pct_sold},
     {'label'=> 'Unsold', 'value'=>100-pct_sold}]
  end

  def top_states_for_graphic
    top_states.map do |active_record|
      {'label'=>active_record.state,
       'value'=>active_record.order_count}
    end
  end

  def revenue_by_month_for_graphic
    today = DateTime.now
    this_month = Date.new(today.year, today.month)
    from_db = items
    .joins(:orders)
    .where("orders.status = 2")
    .where("orders.updated_at": (this_month - 1.year)..today)
    .select("EXTRACT( YEAR FROM orders.updated_at) as year, EXTRACT( MONTH FROM orders.updated_at) as month")
    .select("SUM(order_items.quantity * order_items.ordered_price) as revenue")
    .group("year,month")
    .order("year ASC, month ASC")

    from_db.map do |active_record|
      {'date'=>Date.new(active_record.year, active_record.month),
       'revenue' => active_record.revenue}
    end
  end

  def top_cities_for_graphic
    top_cities.map do |active_record|
      {'label'=>active_record.city + ', ' + active_record.state,
       'value'=>active_record.order_count}
    end
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
end
