class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  validates_presence_of :quantity, #numericality checks
                        :ordered_price

  # validates_exclusion_of :fulfilled, in: [nil]
end
