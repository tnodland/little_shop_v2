class Order < ApplicationRecord
  validates_presence_of :user_id, :status

  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items

  enum status: ['pending', 'packaged', 'shipped', 'cancelled']

  def total_count
    self.order_items.sum(:quantity)
  end

  def total_cost
    self.order_items.sum("quantity*ordered_price").to_f
  end
end
