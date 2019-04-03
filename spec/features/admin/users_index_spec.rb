require 'rails_helper'

RSpec.describe "Admin User Index page", type: :feature do
  describe 'when I visit the user index page' do
    before :each do
      @admin = create(:admin)
      @user_1 = create(:user)
      @user_2 = create(:user)
    end

    it 'shows information about each user' do
      visit '/admin/users'

      within "#user-#{@user_1.id}" do
        expect(page).to have_link("User: #{@user_1.name}")
        expect(page).to have_content("Date Registered: #{@user_1.created_at}")
        expect(page).to have_button("Upgrade to Merchant")
      end

      within "#user-#{@user_2.id}" do
        expect(page).to have_link("User: #{@user_2.name} Date Registered: #{@user_2.created_at}")
        expect(page).to have_button("Upgrade to Merchant")
      end
    end
  end
end
