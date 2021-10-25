require 'rails_helper'

RSpec.describe "UsersSignups", type: :system do

  describe 'sign up' do
    context '無効なユーザー情報の場合' do
      it 'sign upに失敗する' do
        visit signup_path
        fill_in "Name", with: " "
        fill_in "Email", with: "user@invalid"
        fill_in "Password", with: "foo"
        fill_in "Password confirmation", with: "bar"
        click_on "Create my account"
        aggregate_failures do
          expect(current_path).to eq users_path
          expect(page).to have_content 'Sign up'
          expect(page).to have_content 'The form contains 4 errors'
        end
      end
    end

    context '有効なユーザー情報の場合' do
      it 'sign upに成功する' do
        visit signup_path
        fill_in "Name", with: "User"
        fill_in "Email", with: "user@invalid.org"
        fill_in "Password", with: "foobar"
        fill_in "Password confirmation", with: "foobar"
        click_on "Create my account"
        expect(page).to have_content "Please check your email to activate your account."
      end
    end
  end
end
