require 'rails_helper'

RSpec.describe 'Cart show page' do
  before :each do
    @item_1, @item_2, @item_3, @item_4 = create_list(:item, 4)
    @empty_cart_message = "Your cart is empty"
  end
  it 'Says the cart is empty if the cart is empty' do
    visit cart_path
    expect(page).to have_content(@empty_cart_message)
  end

  it 'Does not say the cart is empty if there is an item in the cart' do
    visit item_path(@item_1)
    click_button "Add to Cart"

    visit cart_path
    expect(page).not_to have_content(@empty_cart_message)
  end
  it 'Shows all items I have added', type: :view do
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

    visit cart_path

    expect(page).to have_selector('div', id:"cart-item-#{@item_1.id}")
    expect(page).to have_selector('div', id:"cart-item-#{@item_2.id}")
    expect(page).to have_selector('div', id:"cart-item-#{@item_4.id}")
    expect(page).not_to have_selector('div', id:"cart-item-#{@item_3.id}")
  end

  it
end

RSpec.describe 'partial for items in cart' ,type: :view do
  it 'shows all information' do

    item = create(:item)
    quantity = 3
    render 'carts/cart_item', item:item, quantity:quantity
    expect(rendered).to have_selector('div', id:"cart-item-#{item.id}")
    expect(rendered).to have_selector('div', id:"item-name", text:item.name)
    expect(rendered).to have_selector('div', id:"item-merchant", text:item.user.name)
    expect(rendered).to have_selector('div', id:"item-price", text:item.current_price)
    expect(rendered).to have_selector('div', id:"item-quantity", text:quantity)
    expect(rendered).to have_selector('div', id:"subtotal", text:"#{item.current_price * quantity}")
  end
end
