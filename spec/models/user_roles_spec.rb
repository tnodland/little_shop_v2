require 'rails_helper'

RSpec.describe User do
  describe 'roles' do
    it 'can create an admin' do
      admin = create(:admin)

      expect(user.role).to eq("admin")
      expect(user.admin?).to be_truthy
    end

    it 'can create a merchant' do
      admin = create(:merchant)

      expect(user.role).to eq("merchant")
      expect(user.merchant?).to be_truthy
    end
    it 'can create an admin' do
      admin = create(:user)

      expect(user.role).to eq("user")
      expect(user.user?).to be_truthy
    end
  end
end
