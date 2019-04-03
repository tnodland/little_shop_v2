require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :street_address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip_code}
    it {should validate_presence_of :email}
    it {should validate_presence_of :password}
    it {should validate_presence_of :role}
    # it {should validate_exclusion_of(:enabled).in_array([nil])}
    it {should validate_uniqueness_of :email}
    it {should define_enum_for :role}
  end

  describe 'relationships' do
    it {should have_many :items}
    it {should have_many :orders}
  end

  describe 'roles' do
    it 'can create an admin' do
      user = create(:admin)

      expect(user.role).to eq("admin")
      expect(user.admin?).to be_truthy
    end

    it 'can create a merchant' do
      user = create(:merchant)

      expect(user.role).to eq("merchant")
      expect(user.merchant?).to be_truthy
    end
    it 'can create an admin' do
      user = create(:user)

      expect(user.role).to eq("user")
      expect(user.user?).to be_truthy
    end
  end
end
