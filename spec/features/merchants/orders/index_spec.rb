require 'rails_helper'

RSpec.describe 'Merchant Item Index', type: :feature do
  before :each do
    @merchant = create(:merchant)
    # @items = create_list(:item,2,  user: @merchant)
    # @inactive_item = create(:inactive_item, user: @merchant)
    #
    # @order_items_1 = create_list(:order_item, 3, item:@items[0])
    # @order_item_inactive = create(:order_item, item:@inactive_item)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
  end

  it 'Shows all Profile Information' do
    visit dashboard_path
    expect(page).to have_content(@merchant.name)
    expect(page).to have_content(@merchant.street_address)
    expect(page).to have_content(@merchant.city)
    expect(page).to have_content(@merchant.state)
    expect(page).to have_content(@merchant.zip_code)
    expect(page).to have_content(@merchant.email)
  end

end
