require 'rails_helper'

RSpec.describe 'User Order Index', type: :feature do
  describe 'As a Registerd User' do

    before :each do
      @user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'shows a link on user profile that goes to /profile/orders' do
      visit profile_path

      click_link "View Your Orders"

      expect(current_path).to eq('/profile/orders')
    end
  end
end
