require 'rails_helper'

RSpec.describe "UsersLogins", type: :system do
  let!(:user) { create(:user) }

  describe 'login' do
    context '有効なメールアドレス、無効なパスワードの場合' do
      it 'ログインに失敗する' do
        visit login_path
        expect(page).to have_content 'Log in'
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'invalid'
        click_button "Log in"
        expect(page).to have_content 'Log in'
        visit root_path
        expect(page).not_to have_content 'Invalid email/password combination'
      end
    end
  
    context 'メールアドレス、パスワードの両方が無効な場合' do
      it 'ログインに失敗する' do 
        visit login_path
        expect(page).to have_content 'Log in'
        fill_in 'Email', with: ''
        fill_in 'Password', with: ''
        click_button "Log in"
        expect(page).to have_content 'Log in'
        visit root_path
        expect(page).not_to have_content 'Invalid email/password combination'
      end
    end

    context 'メールアドレス、パスワードの両方が有効な場合' do
      it 'ログインに成功する' do
        visit login_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button "Log in"
        expect(page).to have_current_path user_path(user)
        expect(page).not_to have_link login_path
        click_link 'Account'
        expect(page).to have_link 'profile', href: user_path(user)
        expect(page).to have_link 'Log out', href: logout_path
      end
    end
  end

  describe 'logout' do
    subject { page }
    it 'ログアウトする' do
      signin(user)
      click_link 'Account'
      click_link 'Log out'
      is_expected.to have_current_path root_path
      is_expected.to have_link 'Log in', href: login_path
      is_expected.not_to have_link 'Account'
      is_expected.not_to have_link nil, href: logout_path
      is_expected.not_to have_link nil, href: user_path(user)
    end
  end

  describe 'login with remembering' do
    before { @user = create(:user) }

    it 'login状態を記憶する' do
      log_in_as(@user, remember_me: '1')
      expect(cookies[:remember_token]).not_to eq nil
    end

    it 'login状態を記憶しない' do
      # cookiesを保存してログイン
      log_in_as(@user, remember_me: '1')
      delete logout_path
      # cookiesを削除してログイン
      log_in_as(@user, remember_me: '0')
      expect(cookies[:remember_token].empty?).to be_truthy 
    end 
  end
end