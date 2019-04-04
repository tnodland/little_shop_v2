require 'rails_helper'

feature 'Logging In' do
  scenario 'as a User' do
    user = create(:user)
    visit login_path

    fill_in 'email', with: user.email
    fill_in 'password', with: user.password

    click_button 'Log In'

    expect(page).to have_current_path(profile_path)
  end
end
