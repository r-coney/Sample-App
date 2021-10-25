require 'rails_helper'

RSpec.describe 'site layout', type: :system do
  
  describe 'root_path' do
    before { visit root_path }
    subject { page }
      it 'root, help,about,contactのリンクがあることを確認' do
        is_expected.to have_link nil, href: root_path
        is_expected.to have_link 'Help', href: help_path
        is_expected.to have_link 'About', href: about_path
        is_expected.to have_link 'Contact', href: contact_path
        visit contact_path
        is_expected.to have_title full_title("Contact")
        visit signup_path
        is_expected.to have_title full_title("Sign up")
      end
  end

  describe 'ログインしている時のサイトレイアウト' do
    let(:user) { create(:user) }
    subject { page }

    it 'users,profile,settings,logoutのリンクがあることを確認' do
      signin(user)
      is_expected.to have_current_path user_path(user)
      visit root_path
      is_expected.to have_link 'Users', href: users_path
      click_link 'Account'
      is_expected.to have_link 'profile', href: user_path(user)
      is_expected.to have_link 'settings', href: edit_user_path(user)
      is_expected.to have_link 'Log out', href: logout_path
    end
  end
end