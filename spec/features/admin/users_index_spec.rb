require 'rails_helper'

RSpec.describe "Admin User Index page", type: :feature do
  describe 'when I visit the user index page' do
    before :each do
      @admin = create(:admin)
      @user_1 = create(:user)
      @user_2 = create(:user)
      @merchant_1 = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    it 'allows an admin to visit the index from the nav bar' do
      visit root_path

      click_link "Users"

      expect(current_path).to eq(admin_users_path)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)

      visit root_path

      expect(page).to_not have_link("Users")
    end

    it 'shows information about each user' do

      visit '/admin/users'

      within "#user-#{@user_1.id}" do
        expect(page).to have_link("#{@user_1.name}")
        expect(page).to have_content("Date Registered: #{@user_1.created_at}")
        expect(page).to have_button("Upgrade to Merchant")
      end

      within "#user-#{@user_2.id}" do
        expect(page).to have_link("#{@user_2.name}")
        expect(page).to have_content("Date Registered: #{@user_2.created_at}")
        expect(page).to have_button("Upgrade to Merchant")
      end
    end
  end
end
