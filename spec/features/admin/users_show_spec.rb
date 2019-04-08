require 'rails_helper'

RSpec.describe "Admin User show page", type: :feature do
  describe 'when I visit the user show page' do
    before :each do
      @admin = create(:admin)
      @user_1 = create(:user)
      @user_2 = create(:user)
      @merchant_1 = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    it "Shows all the same information a normal user would see in their profile" do
      visit admin_users_path

      within "#user-#{@user_1.id}" do
        click_link "#{@user_1.name}"
      end

      expect(current_path).to eq(admin_user_path(@user_1))

      expect(page).to have_content("Name: #{@user_1.name}")
      expect(page).to have_content("Street Address: #{@user_1.street_address}")
      expect(page).to have_content("City: #{@user_1.city}")
      expect(page).to have_content("State: #{@user_1.state}")
      expect(page).to have_content("Zip Code: #{@user_1.zip_code}")
      expect(page).to have_content("E-Mail: #{@user_1.email}")
    end
  end
end
