require 'rails_helper'

RSpec.describe 'Cart show page' do
  before :each do
    @item_1, @item_2, @item_3, @item_4 = create_list(:item, 4)
    visit item_path(@item_1)
    click_button "Add to Cart"

    2.times do
      visit item_path(@item_2)
      click_button "Add to Cart"
    end

    4.times do
      visit item_path(@item_4)
      click_button "Add to Cart"
    end

  end

  it 'Shows all items I have added', type: :view do
    visit cart_path

    expect(page).to have_content(@item_1.name)
    expect(page).to have_content(@item_2.name)
    expect(page).to have_content(@item_4.name)
    expect(page).not_to have_content(@item_3.name)
  end
end

RSpec.describe 'partial for items in cart' ,type: :view do
  it 'shows all information' do

    item = create(:item)
    quantity = 3
    render 'carts/cart_item', locals:{item:item, quantity:quantity}
    expect(rendered).to have_selector('div', id:"cart-item-#{item.id}")
    expect(rendered).to have_selector('div', id:"item-name", text:item.name)
    expect(rendered).to have_selector('div', id:"item-merchant", text:item.merchant.name)
    expect(rendered).to have_selector('div', id:"item-price", text:item.price)
    expect(rendered).to have_selector('div', id:"item-quantity", text:quantity)
    expect(rendered).to have_selector('div', id:"subtotal", text:"#{item.price * quantity}")
  end
end
