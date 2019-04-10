require 'rails_helper'

RSpec.describe 'As an Admin User' do
  describe 'dashboard page (orders index) links to admin order show page' do
    before :each do
      @admin = create(:admin)
      @users = create_list(:user, 4)

      @pending_orders = 4.times.map{ |i| create(:order, user:@users[rand(4)], created_at:(i).minute.ago)}
      @shipped_orders = 4.times.map{ |i| create(:shipped_order, user:@users[rand(4)], created_at:(i).minute.ago)}
      @cancelled_orders = 4.times.map{ |i| create(:cancelled_order, user:@users[rand(4)], created_at:(i).minute.ago)}
      @packaged_orders = 4.times.map{ |i| create(:packaged_order, user:@users[rand(4)], created_at:(i).minute.ago)}

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    it 'can navigate to an order show page' do
      visit admin_dashboard_path

      within "#order-#{@pending_orders[0].id}" do
        click_link "Order: #{@pending_orders[0].id}"
      end

      expect(current_path).to eq(admin_user_order_path(@pending_orders[0].user, @pending_orders[0]))
    end
  end
end
