FactoryBot.define do
  factory :order do
    user
    status { 0 }
  end

  factory :packaged_order, parent: :order do
    status { 1 }
  end

  factory :shipped_order, parent: :order do
    status { 2 }
  end

  factory :cancelled_order, parent: :order do
    status { 3 }
  end
end
