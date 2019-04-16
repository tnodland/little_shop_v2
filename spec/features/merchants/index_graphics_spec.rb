require 'rails_helper'

RSpec.describe 'D3 Placehoders', type: :feature do
  it ' Merchant Index has svgs with correct ids' do
    admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    visit merchants_path

    within '#graphics' do
      expect(page).to have_selector('svg', id:'total-sales')
    end
  end
end
