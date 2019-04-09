FactoryBot.define do
  factory :order_item do
    order
    item
    sequence(:quantity) { |n| ("#{n}".to_i+1)}
    ordered_price { 2.5 }
    fulfilled { false }
  end

  factory :fulfilled_order_item, parent: :order_item do
    fulfilled { true }
  end
  factory :fast_fulfilled_order_item, parent: :order_item do
    created_at { "Wed, 03 Apr 2019 14:10:25 UTC +00:00" }
    updated_at { "Thu, 04 Apr 2019 14:11:25 UTC +00:00" }
    fulfilled { true }
  end

  factory :slow_fulfilled_order_item, parent: :order_item do
    created_at { "Wed, 03 Apr 2019 14:10:25 UTC +00:00" }
    updated_at { "Sat, 06 Apr 2019 14:11:25 UTC +00:00" }
    fulfilled { true }
  end
end
