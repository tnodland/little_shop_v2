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
