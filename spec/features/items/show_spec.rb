require 'rails_helper'

RSpec.describe "Item show page" do
  context "as any type of user" do
    it "should see information about an item" do
      merchant = create(:merchant)
      item = create(:item, user: merchant)

      visit item_path(item)

      expect(page).to have_content(item.name)
      expect(page).to have_content(item.description)
      expect(page).to have_content("Seller: #{item.user.name}")
      expect(page).to have_xpath("//img[@src='https://vignette.wikia.nocookie.net/animalcrossing/images/7/72/Tom_Nook.png/revision/latest?cb=20101105231130']")
      expect(page).to have_content("Number in stock: #{item.quantity}")
      expect(page).to have_content("Price: #{item.current_price}")
      expect(page).to have_content("Average Processing Time:")
      expect(page).to have_link("Add to Cart")
    end
  end
end
