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


  end
end
