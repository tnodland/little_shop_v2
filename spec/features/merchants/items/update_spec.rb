require 'rails_helper'

RSpec.describe 'Merchant Item Update', type: :feature do
  before :each do
    @merchant = create(:merchant)
    @items = create_list(:item,2,  user: @merchant)
    @inactive_item = create(:inactive_item, user: @merchant)

    @order_items_1 = create_list(:order_item, 3, item:@items[0])
    @order_item_inactive = create(:order_item, item:@inactive_item)

    @new_item = attributes_for(:item)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
  end
  it 'can disable an item' do
    visit dashboard_items_path
    within "#merchant-item-#{@items[0].id}" do
      click_button "Disable"
    end

    expect(current_path).to eq(dashboard_items_path)
    expect(page).to have_content("#{@items[0].name} Disabled")
    within "#merchant-item-#{@items[0].id}" do
      expect(page).to have_button("Enable")
    end

    expect(Item.find(@items[0].id).enabled).to eq(false)
  end

  it 'can enable an item' do
    visit dashboard_items_path

    within "#merchant-item-#{@inactive_item.id}" do
      click_button "Enable"
    end

    expect(current_path).to eq(dashboard_items_path)

    expect(page).to have_content("#{@inactive_item.name} Enabled")
    within "#merchant-item-#{@inactive_item.id}" do
      expect(page).to have_button("Disable")
    end

    expect(Item.find(@inactive_item.id).enabled).to eq(true)
  end

  it 'can delete an item which has not been ordered' do
    visit dashboard_items_path
    within "#merchant-item-#{@items[1].id}" do
      click_button "Delete"
    end

    expect(page).to have_content("#{@items[1].name} Deleted")
    expect(page).not_to have_selector('div', id:"merchant-item-#{@items[1].id}")
  end
end
