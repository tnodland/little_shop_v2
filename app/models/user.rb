class User < ApplicationRecord
  validates_presence_of :name,
                        :street_address,
                        :city,
                        :state,
                        :zip_code,
                        :email,
                        :password,
                        :role

  validates_uniqueness_of :email

  validates_inclusion_of :enabled, in: [true, false]

  has_many :orders
  has_many :items, foreign_key: "merchant_id"

  enum role: ['user', 'merchant', 'admin']
end
