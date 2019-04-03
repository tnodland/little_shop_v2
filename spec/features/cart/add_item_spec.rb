require 'rails_helper'

RSpec.describe 'Add Item to Cart' do
  before :each do
    @item = create(:item)
    @user = create(:user)
  end
  context 'as a visitor' do
    context 'From an item show page' do
      it 'redirects to item index after clicking add to cart, displaying message that item has been added' do
        visit item_path(@item)
        click_button "Add to Cart"
        expect(current_path).to eq(items_path)
        expect(page).to have_content("You added #{@item.name} to your cart")
      end
    end
    context 'Cart Total updates' do
      it 'after adding first and second item' do
        visit item_path(@item)
        click_button "Add to Cart"

        within "nav.main-nav" do
          expect(page).to have_content("Cart: 1")
        end

        visit item_path(@item)
        click_button "Add to Cart"

        within "nav.main-nav" do
          expect(page).to have_content("Cart: 2")
        end
      end
    end

  end

  context 'As a user' do

    context 'Cart Total updates' do
      it 'after adding first and second item' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        
        visit item_path(@item)
        click_button "Add to Cart"

        within "nav.main-nav" do
          expect(page).to have_content("Cart: 1")
        end

        visit item_path(@item)
        click_button "Add to Cart"

        within "nav.main-nav" do
          expect(page).to have_content("Cart: 2")
        end
      end
    end
  end
end
