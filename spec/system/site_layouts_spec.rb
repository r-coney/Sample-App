require 'rails_helper'

RSpec.describe 'site layout', type: :system do
  
  describe 'root_path' do
    before { visit root_path }
    subject { page }
      it 'root, help,about,contactのリンクがあることを確認' do
        is_expected.to have_link nil, href: root_path
        is_expected.to have_link 'ヘルプ', href: help_path
        is_expected.to have_link 'Sample Appについて', href: about_path
        is_expected.to have_link 'お問い合わせ', href: contact_path
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
      is_expected.to have_link '全てのユーザー', href: users_path
      click_link 'アカウント'
      is_expected.to have_link 'プロフィール', href: user_path(user)
      is_expected.to have_link '設定', href: edit_user_path(user)
      is_expected.to have_link 'ログアウト', href: logout_path
    end
  end
end