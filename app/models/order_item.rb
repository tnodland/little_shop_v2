class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  validates_presence_of :order_id,
                        :item_id,
                        :quantity,
                        # :fulfilled,
                        :ordered_price
end
