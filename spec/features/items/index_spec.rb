require 'rails_helper'

RSpec.describe "Items index page" do
  context "as any kind of user" do
    before :each do
      @merchant1  = create(:merchant)
      @merchant2  = create(:merchant)
      @item1 = create(:item, user: @merchant1)
      @item2 = create(:item, user: @merchant2)
      @item3 = create(:inactive_item, user: @merchant1)
    end

    it "can see all enabled items" do

      visit items_path

      within "#item-#{@item1.id}" do
        expect(page).to have_link(@item1.name)
        expect(page).to have_xpath("//img[@src='https://vignette.wikia.nocookie.net/animalcrossing/images/7/72/Tom_Nook.png/revision/latest?cb=20101105231130']")
        expect(page).to have_content("Sold by: #{@merchant1.name}")
        expect(page).to have_content("Quantity: #{@item1.quantity}")
        expect(page).to have_content("Price: $#{@item1.current_price}")
      end

      within "#item-#{@item2.id}" do
        expect(page).to have_link(@item2.name)
        expect(page).to have_xpath("//img[@src='https://vignette.wikia.nocookie.net/animalcrossing/images/7/72/Tom_Nook.png/revision/latest?cb=20101105231130']")
        expect(page).to have_content(@merchant2.name)
        expect(page).to have_content(@item2.quantity)
        expect(page).to have_content(@item2.current_price)
      end

      expect(page).to_not have_content(@item3.name)
    end

    it "can see statistics about popular items" do
      item4 = create(:item, user: @merchant1)
      item5 = create(:item, user: @merchant1)
      item6 = create(:item, user: @merchant1)
      item7 = create(:item, user: @merchant1)
      item8 = create(:item, user: @merchant1)
      item9 = create(:item, user: @merchant1)
      item10 = create(:item, user: @merchant1)

      shopper = create(:user)
      order = create(:shipped_order, user: shopper)

      create(:fulfilled_order_item, order: order, item: @item1, quantity: @item1.quantity)
      create(:fulfilled_order_item, order: order, item: @item2, quantity: @item2.quantity)
      create(:fulfilled_order_item, order: order, item: @item3, quantity: @item3.quantity)
      create(:fulfilled_order_item, order: order, item: item4, quantity: item4.quantity)
      create(:fulfilled_order_item, order: order, item: item5, quantity: item5.quantity)
      create(:fulfilled_order_item, order: order, item: item6, quantity: item6.quantity)
      create(:fulfilled_order_item, order: order, item: item7, quantity: item7.quantity)
      create(:fulfilled_order_item, order: order, item: item8, quantity: item8.quantity)
      create(:fulfilled_order_item, order: order, item: item9, quantity: item9.quantity)
      create(:fulfilled_order_item, order: order, item: item10, quantity: item10.quantity)

      visit items_path

      within "#most-popular-items" do
        expect(page).to have_content("5 Most Popular Items:")
        expect(page.all("#item")[0]).to have_content("#{item10.name}: #{item10.total_sold} sold")
        expect(page.all("#item")[1]).to have_content("#{item9.name}: #{item9.total_sold} sold")
        expect(page.all("#item")[2]).to have_content("#{item8.name}: #{item8.total_sold} sold")
        expect(page.all("#item")[3]).to have_content("#{item7.name}: #{item7.total_sold} sold")
        expect(page.all("#item")[4]).to have_content("#{item6.name}: #{item6.total_sold} sold")
      end

      within "#least-popular-items" do
        expect(page).to have_content("5 Least Popular Items:")
        expect(page.all("#item")[0]).to have_content("#{item1.name}: #{item1.total_sold} sold")
        expect(page.all("#item")[1]).to have_content("#{item2.name}: #{item2.total_sold} sold")
        expect(page.all("#item")[2]).to have_content("#{item3.name}: #{item3.total_sold} sold")
        expect(page.all("#item")[3]).to have_content("#{item4.name}: #{item4.total_sold} sold")
        expect(page.all("#item")[4]).to have_content("#{item5.name}: #{item5.total_sold} sold")
      end
    end
  end
end
