class Order < ApplicationRecord
  validates_presence_of :user_id, :status

  belongs_to :user
  belongs_to :order_items
  has_many :order_items
  has_many :items, through: :order_items

  enum status: ['pending', 'packaged', 'shipped', 'cancelled']
end
