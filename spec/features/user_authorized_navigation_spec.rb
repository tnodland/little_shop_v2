require 'rails_helper'

RSpec.describe 'User' do
  before :each do
    @user = create(:user)
    @admin = create(:admin)
    @merchant = create(:merchant)
    @error_content = "The page you were looking for doesn't exist"
  end

  describe 'visits /profile' do
    context 'as a visitor' do
      it 'gives 404' do
        visit profile_path
        expect(page).to have_content(@error_content)
      end
    end

    context 'as a user' do
      it 'shows the profile' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        visit profile_path
        expect(page).not_to have_content(@error_content)
      end
    end

    context 'as a merchant' do
      it 'gives 404' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        visit profile_path
        expect(page).to have_content(@error_content)
      end
    end

    context 'as an admin' do
      it 'give 404' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
        visit profile_path
        expect(page).to have_content(@error_content)
      end
    end
  end

  describe 'visits /dashboard' do
    context 'as a visitor' do
      it 'gives 404' do
        visit dashboard_path
        expect(page).to have_content(@error_content)
      end
    end

    context 'as a user' do
      it 'gives 404' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        visit dashboard_path
        expect(page).to have_content(@error_content)
      end
    end

    context 'as a merchant' do
      it 'shows the dashboard' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        visit dashboard_path
        expect(page).not_to have_content(@error_content)
      end
    end

    context 'as an admin' do
      it 'give 404' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
        visit dashboard_path
        expect(page).to have_content(@error_content)
      end
    end
  end

  describe 'visits /cart' do
    context 'as a visitor' do
      it 'shows the cart' do
        visit cart_path
        expect(page).not_to have_content(@error_content)
      end
    end

    context 'as a user' do
      it 'shows the cart' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        visit cart_path
        expect(page).not_to have_content(@error_content)
      end
    end

    context 'as a merchant' do
      it 'gives 404' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        visit cart_path
        expect(page).to have_content(@error_content)
      end
    end

    context 'as an admin' do
      it 'give 404' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
        visit cart_path
        expect(page).to have_content(@error_content)
      end
    end
  end

  describe 'visits any /admin path' do
    context 'as a visitor' do
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

    context 'as a user' do
      it 'gives 404' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
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

    context 'as a merchant' do
      it 'gives 404' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
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

    context 'as an admin' do
      it 'shows page' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
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
end
