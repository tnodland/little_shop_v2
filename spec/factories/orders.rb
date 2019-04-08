FactoryBot.define do
  factory :order do
    user
    status { 0 }
  end

  factory :packaged_order, parent: :order do
    status { 1 }
  end

  factory :fast_shipped_order, parent: :order do
    created_at { "Wed, 03 Apr 2019 14:10:25 UTC +00:00" }
    updated_at { "Thu, 04 Apr 2019 14:11:25 UTC +00:00" }
    status { 2 }
  end

  factory :slow_shipped_order, parent: :order do
    created_at { "Wed, 03 Apr 2019 14:10:25 UTC +00:00" }
    updated_at { "Sat, 06 Apr 2019 14:11:25 UTC +00:00" }
    status { 2 }
  end
  
  factory :cancelled_order, parent: :order do
    status { 3 }
  end
end
