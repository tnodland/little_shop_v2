require 'rails_helper'

RSpec.describe 'as a visitor' do
  before :each do
    @error_content = "The page you were looking for doesn't exist"
    user = create(:user)
  end

  scenario 'attempting to visit unauthorized pages' do
    it 'sees 404 error' do
      visit profile_path
      expect(page).to have_content(@error_content)

      visit dashboard_path
      expect(page).to have_content(@error_content)

      visit admin_dashboard_path
      expect(page).to have_content(@error_content)

      visit admin_users_path
      expect(page).to have_content(@error_content)

      visit admin_user_path(User.last)
      expect(page).to have_content(@error_content)

      visit admin_merchant_path(User.last)
      expect(page).to have_content(@error_content)
    end
  end

  scenario 'attempting to visit authorized pages' do
    it 'sees page content' do
      visit cart_path
      expect(page).not_to have_content(@error_content)
    end
  end
end

RSpec.describe 'as a user' do
  before :each do
    @error_content = "The page you were looking for doesn't exist"
    @user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  scenario 'attempting to visit unauthorized pages' do
    it 'sees 404 error' do
      visit dashboard_path
      expect(page).to have_content(@error_content)

      visit admin_dashboard_path
      expect(page).to have_content(@error_content)

      visit admin_users_path
      expect(page).to have_content(@error_content)

      visit admin_user_path(User.last)
      expect(page).to have_content(@error_content)

      visit admin_merchant_path(User.last)
      expect(page).to have_content(@error_content)
    end
  end

  scenario 'attempting to visit authorized pages' do
    it 'sees page content' do
      visit profile_path
      expect(page).not_to have_content(@error_content)

      visit cart_path
      expect(page).not_to have_content(@error_content)
    end
  end
end

RSpec.describe 'as a merchant' do
  before :each do
    @error_content = "The page you were looking for doesn't exist"
    @merchant = create(:merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
  end

  scenario 'attempting to visit unauthorized pages' do
    it 'sees 404 error' do
      visit profile_path
      expect(page).to have_content(@error_content)

      visit cart_path
      expect(page).to have_content(@error_content)

      visit admin_dashboard_path
      expect(page).to have_content(@error_content)

      visit admin_users_path
      expect(page).to have_content(@error_content)

      visit admin_user_path(User.last)
      expect(page).to have_content(@error_content)

      visit admin_merchant_path(User.last)
      expect(page).to have_content(@error_content)
    end
  end

  scenario 'attempting to visit authorized pages' do
    it 'sees page content' do
      visit dashboard_path
      expect(page).not_to have_content(@error_content)
    end
  end
end

RSpec.describe 'as an admin' do
  before :each do
    @error_content = "The page you were looking for doesn't exist"
    @admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  scenario 'attempting to visit unauthorized pages' do
    it 'sees 404 error' do
      visit profile_path
      expect(page).to have_content(@error_content)
      visit dashboard_path
      expect(page).to have_content(@error_content)
      visit cart_path
      expect(page).to have_content(@error_content)
    end
  end

  scenario 'attempting to visit authorized pages' do
    it 'sees page content' do
      visit admin_dashboard_path
      expect(page).not_to have_content(@error_content)

      visit admin_users_path
      expect(page).not_to have_content(@error_content)

      visit admin_user_path(User.last)
      expect(page).not_to have_content(@error_content)

      visit admin_merchant_path(User.last)
      expect(page).not_to have_content(@error_content)
    end
  end
end
