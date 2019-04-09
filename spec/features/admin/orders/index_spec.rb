require 'rails_helper'

RSpec.describe 'As an Admin User' do
  describe 'dashboard page (orders index)' do
    before :each do
      @admin = create(:admin)
      @users = create_list(:user, 4)

      @pending_orders = 4.times.map{ |i| create(:order, user:@users[rand(4)], created_at:(i).minute.ago)}
      @shipped_orders = 4.times.map{ |i| create(:shipped_order, user:@users[rand(4)], created_at:(i).minute.ago)}
      @cancelled_orders = 4.times.map{ |i| create(:cancelled_order, user:@users[rand(4)], created_at:(i).minute.ago)}
      @packaged_orders = 4.times.map{ |i| create(:packaged_order, user:@users[rand(4)], created_at:(i).minute.ago)}

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
          expect(page).to have_link(order.user.id.to_s, href:admin_user_path(order.user))
        end
      end
    end

    it 'gives orders in sorted order, by category, then by newest to oldest' do
      visit admin_dashboard_path

      desired = @packaged_orders + @pending_orders + @shipped_orders + @cancelled_orders

      observed = page.all('span', class:'order-row')

      observed.zip(desired).each do |obs, expected|
        obs_id = obs[:id].split("-")[1].to_i
        expect(obs_id).to eq(expected.id)
      end

    end

    context 'can ship packaged orders' do
      it 'has button to ship orders' do
        all_orders = @packaged_orders + @pending_orders + @shipped_orders + @cancelled_orders

        visit admin_dashboard_path

        all_orders.each do |order|

          within "#order-#{order.id}" do
            if order.status == 'packaged'
              expect(page).to have_button("Ship")
            else
              expect(page).not_to have_button("Ship")
            end
          end
        end
      end

      it 'can change status to shipped' do
        visit admin_dashboard_path
        within "#order-#{@packaged_orders[0].id}" do
          click_button "Ship"
        end

        expect(current_path).to eq(admin_dashboard_path)
        within "#order-#{@packaged_orders[0].id}" do
          expect(page).to have_content("shipped")
          expec(page).not_to have_button("Ship")
        end

      end
    end

  end
end
