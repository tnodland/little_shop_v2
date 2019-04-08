require 'rails_helper'

RSpec.describe 'Merchant Orders Index (Dashboard)', type: :feature do
  before :each do
    @merchant = create(:merchant)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
  end

  it 'can navigate to the merchant items page' do
    visit dashboard_path
    click_link "View Items"
    expect(current_path).to eq(dashboard_items_path)
  end
end
