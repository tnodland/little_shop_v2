require 'rails_helper'

RSpec.describe 'Merchant Item Index', type: :feature do
  before :each do
    @merchant = create(:merchant)
    @items = create_list(:item,2,  user: @merchant)
    @inactive_item = create(:inactive_item, user: @merchant)

    @order_items_1 = create_list(:order_item, 3, item:@items[0])
    @order_item_inactive = create(:order_item, item:@inactive_item)

    @new_item = attributes_for(:item)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
  end

  it 'has an item index page displaying all items' do
    visit dashboard_items_path

    expect(page).to have_selector('div', id:"merchant-item-#{@items[0].id}")
    expect(page).to have_selector('div', id:"merchant-item-#{@items[1].id}")
    expect(page).to have_selector('div', id:"merchant-item-#{@inactive_item.id}")
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
    expect(item.name).to eq(@new_item[:name])
    expect(item.description).to eq(@new_item[:description])
    expect(item.image_url).to eq(@new_item[:image_url])
    expect(item.current_price).to eq(@new_item[:current_price])
    expect(item.quantity).to eq(@new_item[:quantity])
    expect(item.enabled).to eq(true)
    expect(item.merchant_id).to eq(@merchant.id)

  end

  describe 'validates information for new items, returning to form with message if incorrect' do
    it 'can leave the url blank'


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

      fill_in "Quantity", with: 1.5
      expect(page).to have_content("Quantity must be an interger")

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

      expect(page).to have_content("Current price can't be blank")

      fill_in "Price", with:0.00
      click_button "Create Item"
      expect(page).to have_content("Current price must be greater than 0")

      fill_in "Price", with: -1.00
      expect(page).to have_content("Current price must be greater than 0")
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

RSpec.describe 'Merchant_Item partial', type: :view do
  before :each do
    @active_unordered_item = create(:item)
    @inactive_item = create(:inactive_item)
    @ordered_item = create(:item)
    @order_item = create(:order_item, item: @ordered_item)
  end
  it 'shows all item information' do
    render 'shared/merchant_item', item:@active_unordered_item

    expect(rendered).to have_selector('div', id:"merchant-item-#{@active_unordered_item.id}")
    expect(rendered).to have_selector('div', id: 'item-id', text: @active_unordered_item.id)
    expect(rendered).to have_selector('div', id: 'item-name', text: @active_unordered_item.name)
    expect(rendered).to have_selector('div', id: 'item-price', text: @active_unordered_item.current_price)
    expect(rendered).to have_selector('div', id: 'item-quantity', text: @active_unordered_item.quantity)
    expect(rendered).to have_xpath("//img[@src='#{@active_unordered_item.image_url}']")
  end

  it 'Correctly shows disable button' do
    render 'shared/merchant_item', item:@active_unordered_item

    expect(rendered).to have_button("Disable")
    expect(rendered).not_to have_button("Enable")
  end

  it 'Correctly shows enable button' do
    render 'shared/merchant_item', item:@inactive_item

    expect(rendered).not_to have_button("Disable")
    expect(rendered).to have_button("Enable")
  end

  it 'Shows delete button when appropriate' do
    render 'shared/merchant_item', item:@active_unordered_item

    expect(rendered).to have_button("Delete")
  end

  it 'Does not show delete button when not appropriate' do
    render 'shared/merchant_item', item:@ordered_item

    expect(rendered).not_to have_button("Delete")
  end
end