require 'rails_helper'

RSpec.describe "Items index page" do
  context "as any kind of user" do
    it "can see all enabled items" do
      merchant1  = create(:merchant)
      merchant2  = create(:merchant)
      item1 = create(:item, user: merchant1)
      item2 = create(:item, user: merchant2)
      item3 = create(:inactive_item, user: merchant1)

      visit items_path

      within "#item-#{item1.id}" do
        expect(page).to have_link(item1.name)
        expect(page).to have_content(item1.image_url)
        expect(page).to have_content(merchant1.name)
        expect(page).to have_content(item1.quantity)
        expect(page).to have_content(item1.current_price)
      end

      within "#item-#{item2.id}" do
        expect(page).to have_link(item2.name)
        expect(page).to have_content(item2.image_url)
        expect(page).to have_content(merchant2.name)
        expect(page).to have_content(item2.quantity)
        expect(page).to have_content(item2.current_price)
      end

      expect(page).to_not have_content(item3.name)
    end
  end
end
