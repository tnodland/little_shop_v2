require 'rails_helper'

RSpec.describe "User Index Page", type: :feature do
  describe 'As a registered user' do
    before :each do
      @user = create(:user)
    end
    it 'shows information about the user and an edit button' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

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
  end
end
