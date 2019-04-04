require 'rails_helper'

RSpec.describe "Merchant index page" do
  context "as any non admin user" do
    it "can see all merchants and some information" do
      merchants = create_list(:merchant, 3)
      im = create(:inactive_merchant)

      visit merchants_path

      merchants.each do |merchant|
        within "#merchant-#{merchant.id}" do
          expect(page).to have_content("Name: #{merchant.name}")
          expect(page).to have_content("Located in #{merchant.city}, #{merchant.state}")
          expect(page).to have_content("Joined the store on #{merchant.created_at}")
        end
      end

      expect(page).to_not have_content("Name: #{im.name}")
    end
  end

  context "as an admin user" do
    it "sees different information than other users" do

      merchant = create(:merchant)
      im = create(:inactive_merchant)
      admin = create(:admin)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit admin_merchants_path

      within "#merchant-#{merchant.id}" do
        expect(page).to have_content("Name: #{merchant.name}")
        expect(page).to have_link("#{merchant.name}")
        expect(page).to have_content("Located in #{merchant.city}, #{merchant.state}")
        expect(page).to have_content("Joined the store on #{merchant.created_at}")
        expect(page).to have_link("Disable this Merchant")
      end

      within "#merchant-#{im.id}" do
        expect(page).to have_content("Name: #{im.name}")
        expect(page).to have_link("#{im.name}")
        expect(page).to have_content("Located in #{im.city}, #{im.state}")
        expect(page).to have_content("Joined the store on #{im.created_at}")
        expect(page).to have_link("Enable this Merchant")
      end
    end
  end
end
