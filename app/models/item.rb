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
end
