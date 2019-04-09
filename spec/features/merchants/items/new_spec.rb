require 'rails_helper'

RSpec.describe 'Merchant Item Index', type: :feature do
  before :each do
    @merchant = create(:merchant)
    @items = create_list(:item,2,  user: @merchant)
    @inactive_item = create(:inactive_item, user: @merchant)

    @new_item = attributes_for(:item)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
  end

  it 'can add a new item' do
    visit dashboard_items_path
    click_link "Add Item"

    expect(current_path).to eq(new_dashboard_item_path)

    fill_in "Name", with:@new_item[:name]
    fill_in "Description", with:@new_item[:description]
    fill_in "Image URL", with:@new_item[:image_url]
    fill_in "Price", with:@new_item[:current_price]
    fill_in "Quantity", with:@new_item[:quantity]

    click_button "Create Item"

    item = Item.last

    expect(page).to have_content("#{item.name} Saved")
    expect(item.name).to eq(@new_item[:name])
    expect(item.description).to eq(@new_item[:description])
    expect(item.image_url).to eq(@new_item[:image_url])
    expect(item.current_price).to eq(@new_item[:current_price])
    expect(item.quantity).to eq(@new_item[:quantity])
    expect(item.enabled).to eq(true)
    expect(item.merchant_id).to eq(@merchant.id)
  end

  describe 'validates information for new items, returning to form with message if incorrect' do
    it 'can leave the url blank' do

      visit new_dashboard_item_path

      fill_in "Name", with:@new_item[:name]
      fill_in "Description", with:@new_item[:description]
      fill_in "Price", with:@new_item[:current_price]
      fill_in "Quantity", with:@new_item[:quantity]

      click_button "Create Item"
      item = Item.last
      expect(item.image_url).to eq('http://www.spore.com/static/image/500/404/515/500404515704_lrg.png')

      expect(page).to have_xpath("//img[@src='http://www.spore.com/static/image/500/404/515/500404515704_lrg.png']")

    end
    it 'cannot have a quantity of less than 0' do
      visit new_dashboard_item_path

      fill_in "Name", with:@new_item[:name]
      fill_in "Description", with:@new_item[:description]
      fill_in "Image URL", with:@new_item[:image_url]
      fill_in "Price", with:@new_item[:current_price]

      click_button "Create Item"

      expect(page).to have_content("Quantity can't be blank")

      fill_in "Quantity", with:-10
      click_button "Create Item"
      expect(page).to have_content("Quantity must be greater than or equal to 0")

      # Below, this is a kludge-y test, form does not allow input of floats
      # So this is very sad-path of a forced input
      fill_in "Quantity", with:1.5
      expect(page).to have_content("Quantity must be greater than or equal to 0")

      fill_in "Quantity", with: 5
      click_button "Create Item"
      expect(current_path).to eq(dashboard_items_path)

    end

    it 'must have a price greater than 0.00' do
      visit new_dashboard_item_path

      fill_in "Name", with:@new_item[:name]
      fill_in "Description", with:@new_item[:description]
      fill_in "Image URL", with:@new_item[:image_url]
      fill_in "Quantity", with:@new_item[:quantity]

      click_button "Create Item"

      expect(page).to have_content("Price can't be blank")

      fill_in "Price", with:0.00
      click_button "Create Item"
      expect(page).to have_content("Price must be greater than 0")

      fill_in "Price", with: -1.00
      expect(page).to have_content("Price must be greater than 0")
      click_button "Create Item"

      fill_in "Price", with: 1.00
      expect(current_path).to eq(dashboard_items_path)
    end

    it 'must have name' do
      visit new_dashboard_item_path

      fill_in "Description", with:@new_item[:description]
      fill_in "Image URL", with:@new_item[:image_url]
      fill_in "Price", with:@new_item[:current_price]
      fill_in "Quantity", with:@new_item[:quantity]

      click_button "Create Item"
      expect(page).to have_content("Name can't be blank")
    end
    it 'must have description' do
      visit new_dashboard_item_path

      fill_in "Name", with:@new_item[:name]
      fill_in "Image URL", with:@new_item[:image_url]
      fill_in "Price", with:@new_item[:current_price]
      fill_in "Quantity", with:@new_item[:quantity]

      click_button "Create Item"

      expect(page).to have_content("Description can't be blank")
    end
  end
end
