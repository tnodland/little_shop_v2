FactoryBot.define do
  factory :item do
    association :user, factory: :merchant
    sequence(:name) { |n| "Item #{n}"}
    description { "An item you should buy" }
    image_url { "image" }
    sequence(:quantity) { |n| ("#{n}".to_i+1)*2}
    sequence(:current_price) { |n| ("#{n}".to_i+1)*1.5}
    enabled { true }
  end

  factory :inactive_item, parent: :item  do
    association :user, factory: :merchant
    enabled { false }
  end
end
