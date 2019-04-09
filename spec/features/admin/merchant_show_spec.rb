require 'rails_helper'

RSpec.describe 'As an Admin User' do
  describe 'admin/merchant showpage' do
    before :each do
      @admin = create(:admin)
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @user_1 = create(:user)
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

    it 'Allows an admin to downgrade a merchant to a user' do
      create(:item, merchant_id: @merchant_1.id)
      create(:item, merchant_id: @merchant_1.id)

      visit admin_merchant_path(@merchant_1)

      expect(page).to have_link("Downgrade to User")

      click_link "Downgrade to User"

      expect(current_path).to eq(admin_user_path(@merchant_1))
      expect(page).to have_content("#{@merchant_1.name} is now a User")

      item_1 = Item.first
      item_2 = Item.second
      expect(item_1.enabled?).to eq(false)
      expect(item_2.enabled?).to eq(false)

      visit admin_users_path
      expect(page).to have_link(@merchant_1.name)

      visit admin_merchants_path
      expect(page).to_not have_link(@merchant_1.name)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(User.second)

      visit profile_path

      expect(page).to_not have_content("The page you were looking for doesn't exist")
    end
    it 'only allows admins to reach the downgrade path' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)

      visit admin_downgrade_merchant_path(@user_1)
      expect(page).to have_http_status(404)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit admin_downgrade_merchant_path(@user_1)
      expect(page).to have_http_status(404)
    end

    it 'If a path is for merchant but the merchant is a user it is redirected to the users path' do

      visit "/admin/merchants/#{@user_1.id}"

      expect(current_path).to eq(admin_user_path(@user_1))
    end
  end
end
