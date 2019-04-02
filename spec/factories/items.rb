FactoryBot.define do
  factory :item do
    association :user, factory: :merchant
    sequence(:name) { |n| "Item #{n}"}
    description { "An item you should buy" }
    image_url { "https://vignette.wikia.nocookie.net/animalcrossing/images/7/72/Tom_Nook.png/revision/latest?cb=20101105231130" }
    sequence(:quantity) { |n| ("#{n}".to_i+1)*2}
    sequence(:current_price) { |n| ("#{n}".to_i+1)*1.5}
    enabled { true }
  end

  factory :inactive_item, parent: :item  do
    association :user, factory: :merchant
    enabled { false }
  end
end
