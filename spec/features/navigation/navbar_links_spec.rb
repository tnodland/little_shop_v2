require 'rails_helper'

feature 'Navigation Bar' do
  background do
    @home        = {locator: 'Home',           options: {href: '/'}}
    @items       = {locator: 'Browse Items',   options: {href: '/items'}}
    @merchants   = {locator: 'View Merchants', options: {href: '/merchants'}}
    @cart        = {locator: 'Cart',           options: {href: '/cart'}}
    @profile     = {locator: 'Profile',        options: {href: '/profile'}}
    @dashboard_m = {locator: 'Dashboard',      options: {href: '/dashboard'}}
    @dashboard_a = {locator: 'Dashboard',      options: {href: '/admin/dashboard'}}
    @register    = {locator: 'Register',       options: {href: '/register'}}
    @login       = {locator: 'Log In',         options: {href: '/login'}}
    @logout      = {locator: 'Log Out',        options: {href: '/logout'}}
  end

  context 'as a Visitor' do
    it 'should show visitor navigation links' do
      visit root_path
      within 'nav.main-nav' do
        expect(page).to have_link(@home)
        expect(page).to have_link('Home', href: '/')
        expect(page).to have_link(@items)
        expect(page).to have_link(@merchant)
        expect(page).to have_link(@cart)
        expect(page).to have_link(@login)
        expect(page).to have_link(@register)

        expect(page).to_not have_link(@profile)
        expect(page).to_not have_link(@logout)
        expect(page).to_not have_link(@dashboard_m)
        expect(page).to_not have_link(@dashboard_a)
      end
    end
  end
end
