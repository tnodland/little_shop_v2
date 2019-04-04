require 'rails_helper'

feature 'Logging Out' do
  scenario 'any user is logged out' do
    user = create(:user)
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button 'Log In'

    visit logout_path
    expect(page).to have_current_path(root_path)
    within 'div.alert' do
      expect(page).to have_content("You are now logged out.")
    end

    visit cart_path
    expect(page).to have_content("Your cart is empty.")
  end
end
