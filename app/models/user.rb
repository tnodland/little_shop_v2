class User < ApplicationRecord
  validates_presence_of :name,
                        :street_address,
                        :city,
                        :state,
                        :zip_code,
                        :email,
                        :role

  validates_presence_of :password, require: true
  validates_uniqueness_of :email

  validates_exclusion_of :enabled, in: [nil]

  has_many :orders
  has_many :items, foreign_key: "merchant_id"

  enum role: ['user', 'merchant', 'admin']

  has_secure_password
end
