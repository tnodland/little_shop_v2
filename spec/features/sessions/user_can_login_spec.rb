require 'rails_helper'

feature 'Logging In' do
  scenario 'as a User' do
    user = create(:user)
    visit login_path

    fill_in 'email', with: user.email
    fill_in 'password', with: user.password

    click_button 'Log In'

    expect(page).to have_current_path(profile_path)
    expect(page).to have_http_status(200)
    within 'div.alert' do
      expect(page).to have_content("Welcome back, #{user.name}! You are now logged in.")
    end
  end

  scenario 'as a Merchant' do
    user = create(:merchant)
    visit login_path

    fill_in 'email', with: user.email
    fill_in 'password', with: user.password

    click_button 'Log In'

    expect(page).to have_current_path(dashboard_path)
    expect(page).to have_http_status(200)
    within 'div.alert' do
      expect(page).to have_content("You are now logged in.")
    end
  end

  scenario 'as an Admin' do
    user = create(:admin)
    visit login_path

    fill_in 'email', with: user.email
    fill_in 'password', with: user.password

    click_button 'Log In'

    expect(page).to have_current_path(root_path)
    expect(page).to have_http_status(200)
    within 'div.alert' do
      expect(page).to have_content("You are now logged in.")
    end
  end
end
