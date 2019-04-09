require 'rails_helper'

RSpec.describe 'As an Admin User' do
  describe 'dashboard page (orders index)' do
    before :each do
      @admin = create(:admin)
      @users = create_list(:user, 4)

      @packaged_orders = 4.times.map{ create(:packaged_order, user:@users[rand(4)])}
      @pending_orders = 4.times.map{ create(:packaged_order, user:@users[rand(4)])}
      @shipped_orders = 4.times.map{ create(:packaged_order, user:@users[rand(4)])}
      @cancelled_orders = 4.times.map{ create(:packaged_order, user:@users[rand(4)])}

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    it 'shows all order information' do
      all_orders = @packaged_orders + @pending_orders + @shipped_orders + @cancelled_orders

      visit admin_dashboard_path

      all_orders.each do |order|
        within "#order-#{order.id}" do
          expect(page).to have_content(order.created_at)
          expect(page).to have_content(order.status)
          expect(page).to have_content("Order: #{order.id}")
          expect(page).to have_link(order.user.id, href:admin_user_path(order.user))
        end
      end
    end

  end
end
