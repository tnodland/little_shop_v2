class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  validates_presence_of :order_id,
                        :item_id,
                        :quantity,
                        :ordered_price

  validates_exclusion_of :fulfilled, in: [nil]
end
