require 'rails_helper'

RSpec.describe 'site layout', type: :system do
  context 'access to root_path' do
    before { visit root_path }
    subject { page }
    it 'has links sach as root_path, help_path and about_path' do
      is_expected.to have_link nil, href: root_path
      is_expected.to have_link 'Help', href: help_path
      is_expected.to have_link 'About', href: about_path
      is_expected.to have_link 'Contact', href: contact_path
      visit contact_path
      expect(page).to have_title full_title("Contact")
      visit signup_path
      expect(page).to have_title full_title("Sign up")
    end

    before do
      @user = create(:user,:michael)
    end

    it 'layout links when logged in' do
      visit login_path
      fill_in 'Email', with: 'michael@example.com'
      fill_in 'Password', with: 'password'
      click_button "Log in"
      expect(page).to have_current_path user_path(@user)
      visit root_path
      expect(page).to have_link 'Users', href: users_path
      click_link 'Account'
      expect(page).to have_link 'profile', href: user_path(@user)
      expect(page).to have_link 'settings', href: edit_user_path(@user)
      expect(page).to have_link 'Log out', href: logout_path

    end

      
  end
end