require 'rails_helper'

RSpec.describe 'Merchant Item Index', type: :feature do
  before :each do
    @merchant = create(:merchant)
    @active_unordered_item = create(:item, user: @merchant)
    @inactive_item = create(:inactive_item, user: @merchant)
    @ordered_item = create(:item, user: @merchant)
    @order_item = create(:order_item, item: @ordered_item)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
  end

  it 'has an item index page displaying all items' do
    visit dashboard_items_path

    within "#merchant-item-#{@active_unordered_item.id}" do
      expect(page).to have_selector('div', class: 'item-id', text: @active_unordered_item.id)
      expect(page).to have_selector('div', class: 'item-name', text: @active_unordered_item.name)
      expect(page).to have_selector('div', class: 'item-price', text: @active_unordered_item.current_price)
      expect(page).to have_selector('div', class: 'item-quantity', text: @active_unordered_item.quantity)
      expect(page).to have_xpath("//img[@src='#{@active_unordered_item.image_url}']")
      expect(page).to have_link("Edit", href:edit_dashboard_item_path(@active_unordered_item))

      expect(page).to have_button("Disable")
      expect(page).not_to have_button("Enable")
      expect(page).to have_button("Delete")
    end

    within "#merchant-item-#{@inactive_item.id}" do
      expect(page).to have_selector('div', class: 'item-id', text: @inactive_item.id)
      expect(page).to have_selector('div', class: 'item-name', text: @inactive_item.name)
      expect(page).to have_selector('div', class: 'item-price', text: @inactive_item.current_price)
      expect(page).to have_selector('div', class: 'item-quantity', text: @inactive_item.quantity)
      expect(page).to have_xpath("//img[@src='#{@inactive_item.image_url}']")
      expect(page).to have_link("Edit", href:edit_dashboard_item_path(@inactive_item))

      expect(page).not_to have_button("Disable")
      expect(page).to have_button("Enable")
      expect(page).to have_button("Delete")
    end

    within "#merchant-item-#{@ordered_item.id}" do
      expect(page).to have_selector('div', class: 'item-id', text: @ordered_item.id)
      expect(page).to have_selector('div', class: 'item-name', text: @ordered_item.name)
      expect(page).to have_selector('div', class: 'item-price', text: @ordered_item.current_price)
      expect(page).to have_selector('div', class: 'item-quantity', text: @ordered_item.quantity)
      expect(page).to have_xpath("//img[@src='#{@ordered_item.image_url}']")
      expect(page).to have_link("Edit", href:edit_dashboard_item_path(@ordered_item))

      expect(page).to have_button("Disable")
      expect(page).not_to have_button("Enable")
      expect(page).not_to have_button("Delete")
    end

  end

end
