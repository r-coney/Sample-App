require 'rails_helper'

RSpec.describe "UsersEdits", type: :system do
 let(:user) { create(:user) }

  it '無効な送信の場合、ユーザー情報の編集に失敗する' do
    signin(user)
    expect(page).to have_current_path user_path(user)
    visit edit_user_path(user)
    expect(page).to have_content 'Update your profile'
    fill_in 'Name', with: ''
    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: ''
    click_button 'Save changes'
    expect(page).to have_content 'Update your profile'
  end

  it 'ユーザー情報の編集とfriendly forwardingに成功する' do
    visit edit_user_path(user)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button "Log in"
    expect(page).to have_current_path edit_user_path(user)
    visit edit_user_path(user)
    expect(page).to have_content 'Update your profile'
    fill_in 'Name', with: 'Foo Bar'
    fill_in 'Email', with: 'foo@bar.com'
    fill_in 'Password', with: 'foobar'
    fill_in 'Password confirmation', with: 'foobar'
    click_button 'Save changes'
    expect(page).to have_content 'Profile updated'
    expect(page).to  have_content 'Foo Bar'
    user.reload
    expect(user.name).to eq 'Foo Bar' 
    expect(user.email).to eq 'foo@bar.com'
  end  
end
