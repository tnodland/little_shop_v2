require 'rails_helper'

RSpec.describe 'D3 Placehoders', type: :feature do

  before :each do
    @merchant = create(:merchant)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
  end
  it ' Merchant Dashboard has svgs with correct ids' do
    visit dashboard_path

    within ".merchant-stats" do
      within '#graphics' do
        expect(page).to have_selector('svg', id:'percent-sold')
        expect(page).to have_selector('svg', id:'top-cities')
        expect(page).to have_selector('svg', id:'top-states')
        expect(page).to have_selector('svg', id:'revenue')
      end
    end
  end
end
