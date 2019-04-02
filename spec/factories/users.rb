FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}"}
    sequence(:street_address) { |n| "#{n} test street"}
    city { "Testville" }
    state { "Colorado" }
    zip_code { 11111 }
    sequence(:email) { |n| "test#{n}@mail.com"}
    password { "password" }
    enabled { true }
    role { 0 }
  end

  factory :inactive_user, parent: :user do
    enabled { false }
  end

  factory :merchant, parent: :user do
    sequence(:name) { |n| "Merchant #{n}"}
    role { 1 }
  end

  factory :inactive_merchant, parent: :user do
    sequence(:name) { |n| "Inactive Merchant #{n}"}
    role { 1 }
    enabled {false}
  end

  factory :admin, parent: :user do
    sequence(:name) { |n| "Admin #{n}"}
    role { 2 }
  end
end
