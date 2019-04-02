FactoryBot.define do
  factory :order_item do
    order
    item
    quantity { 1 }
    ordered_price { 2.5 }
    fulfilled { false }
  end

  factory :fulfilled_order_item, parent: :order_item do
    fulfilled { true }
  end
end
