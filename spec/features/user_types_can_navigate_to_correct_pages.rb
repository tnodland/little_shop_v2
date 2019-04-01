require 'rails_helper'

RSpec.describe 'User visits /profile' do
  context 'as a visitor' do
    it 'gives 404' do
      visit profile_path
      expect(page).to have_content("The page you were looking for doesn't exist")
    end
  end

  context 'as a customer' do
    it 'shows the profile' do
      user = create(:customer)
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log In"

      visit profile_path
      expect(page).not_to have_content("The page you were looking for doesn't exist")
    end
  end
end
