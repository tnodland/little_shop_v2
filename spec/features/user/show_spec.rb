require 'rails_helper'

RSpec.describe "User Index Page", type: :feature do
  describe 'As a registered user' do
    before :each do
      @user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end
    it 'shows information about the user and an edit button' do

      visit profile_path

      expect(page).to have_content("Name: #{@user.name}")
      expect(page).to have_content("Street Address: #{@user.street_address}")
      expect(page).to have_content("City: #{@user.city}")
      expect(page).to have_content("State: #{@user.state}")
      expect(page).to have_content("Zip Code: #{@user.zip_code}")
      expect(page).to have_content("Email: #{@user.email}")
      expect(page).to have_link("Edit Profile")
      expect(page).to_not have_content(@user.password)
    end

    it 'lets a user edit their information' do

      visit profile_path

      click_link "Edit Profile"
      expect(current_path).to eq(edit_profile_path)

      fill_in "Name", with: "steve"
      fill_in "Street Address", with: "123 st"
      fill_in "City", with: "ranch"
      fill_in "State", with: "co"
      fill_in "Zip Code", with: "01234"
      fill_in "email", with: "mail@mail.com"
      fill_in "Password", with: "password"
      fill_in "Confirm Password", with: "password"

      click_button "Edit Profile"

      expect(current_path).to eq(profile_path)

      expect(page).to have_content("Name: steve")
      expect(page).to have_content("Street Address: 123 st")
      expect(page).to have_content("City: ranch")
      expect(page).to have_content("State: co")
      expect(page).to have_content("Zip Code: 01234")
      expect(page).to have_content("Email: mail@mail.com")
      expect(page).to have_link("Edit Profile")
      expect(page).to_not have_content("password")
    end
  end
end
