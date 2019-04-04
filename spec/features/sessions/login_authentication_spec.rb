require 'rails_helper'

feature 'Logging In' do
  describe 'with valid credentials' do
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

  scenario 'with invalid credentials' do
    user = create(:user)
    visit login_path

    fill_in 'email', with: "nonsense"
    fill_in 'password', with: user.password

    click_button 'Log In'

    expect(page).to have_current_path(login_path)
    within 'div.alert' do
      expect(page).to have_content("Incorrect email address or password.")
    end

    fill_in 'email', with: user.email
    fill_in 'password', with: "more nonsense"

    click_button 'Log In'

    expect(page).to have_current_path(login_path)
    within 'div.alert' do
      expect(page).to have_content("Incorrect email address or password.")
    end
  end

  describe 'if already logged in, should be redirected' do
    scenario 'as a User' do
      user = create(:user)
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'Log In'
      visit login_path

      expect(page).to have_current_path(profile_path)
      within 'div.alert' do
        expect(page).to have_content("You are already logged in.")
      end
    end

    scenario 'as a Merchant' do
      user = create(:merchant)
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'Log In'
      visit login_path

      expect(page).to have_current_path(dashboard_path)
      within 'div.alert' do
        expect(page).to have_content("You are already logged in.")
      end
    end

    scenario 'as an Admin' do
      user = create(:admin)
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'Log In'
      visit login_path

      expect(page).to have_current_path(root_path)
      within 'div.alert' do
        expect(page).to have_content("You are already logged in.")
      end
    end
  end
end
