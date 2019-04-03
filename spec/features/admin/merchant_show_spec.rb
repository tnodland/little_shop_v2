require 'rails_helper'

RSpec.describe 'As an Admin User' do
  describe 'admin/merchant showpage' do
    before :each do
      @admin = create(:admin)
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end
    it 'shows all the same information that a merchant would see' do
      visit admin_merchants_path

      within "#merchant-#{@merchant_1.id}" do
        click_link "#{@merchant_1.name}"
      end

      expect(current_path).to eq("/admin/merchants/#{@merchant_1.id}")

      expect(page).to have_content("Name: #{@merchant_1.name}")
      expect(page).to have_content("Street Address: #{@merchant_1.street_address}")
      expect(page).to have_content("City: #{@merchant_1.city}")
      expect(page).to have_content("State: #{@merchant_1.state}")
      expect(page).to have_content("Zip Code: #{@merchant_1.zip_code}")
      expect(page).to have_content("E-Mail: #{@merchant_1.email}")
    end
  end
end
