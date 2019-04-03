require 'rails_helper'

RSpec.describe 'Add Item to Cart' do
  before :each do
    @item = create(:item)
  end
  context 'From an item show page' do
    it 'redirects to item index after clicking add to cart, displaying message that item has been added' do
      visit item_path(@item)
      click_button "Add to Cart"
      expect(current_path).to eq(items_path)
      expect(page).to have_content("You added #{@item.name} to your cart")
    end
  end

end
