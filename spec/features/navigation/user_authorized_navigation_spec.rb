require 'rails_helper'

RSpec.describe 'as a visitor' do
  before :each do
    @error_content = "The page you were looking for doesn't exist"
    user = create(:user)
  end

  it 'gives 404 at profile page' do
    visit profile_path
    expect(page).to have_content(@error_content)
  end

  it 'gives 404 at dashboard' do
    visit dashboard_path
    expect(page).to have_content(@error_content)
  end

  it 'shows the cart' do
    visit cart_path
    expect(page).not_to have_content(@error_content)
  end

  context 'visit any admin path' do
    it 'gives 404' do
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
end

RSpec.describe 'as a user' do
  before :each do
    @error_content = "The page you were looking for doesn't exist"
    @user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it 'shows the profile page' do
    visit profile_path
    expect(page).not_to have_content(@error_content)
  end

  it 'gives 404 at dashboard' do
    visit dashboard_path
    expect(page).to have_content(@error_content)
  end

  it 'shows the cart' do
    visit cart_path
    expect(page).not_to have_content(@error_content)
  end

  context 'visit any admin path' do
    it 'gives 404' do

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
end

RSpec.describe 'as a merchant' do
  before :each do
    @error_content = "The page you were looking for doesn't exist"
    @merchant = create(:merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
  end

  it 'gives 404 at profile page' do
    visit profile_path
    expect(page).to have_content(@error_content)
  end

  it 'shows the dashboard' do
    visit dashboard_path
    expect(page).not_to have_content(@error_content)
  end

  it 'gives 404 at the cart' do
    visit cart_path
    expect(page).to have_content(@error_content)
  end

  context 'visit any admin path' do
    it 'gives 404' do

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
end

RSpec.describe 'as an admin' do
  before :each do
    @error_content = "The page you were looking for doesn't exist"
    @admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  it 'gives 404 at profile page' do
    visit profile_path
    expect(page).to have_content(@error_content)
  end

  it 'gives 404 at dashboard' do
    visit dashboard_path
    expect(page).to have_content(@error_content)
  end

  it 'give 404 at cart' do
    visit cart_path
    expect(page).to have_content(@error_content)
  end

  context 'visit any admin path' do
    it 'shows page' do
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
