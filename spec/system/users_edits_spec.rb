require 'rails_helper'

RSpec.describe "UsersEdits", type: :system do
  before do
    @user = create(:user, :michael)
  end

  it 'unsuccessful edit' do
    visit login_path
    fill_in 'Email', with: 'michael@example.com'
    fill_in 'Password', with: 'password'
    click_button "Log in"
    expect(page).to have_current_path user_path(@user)
    visit edit_user_path(@user)
    expect(page).to have_content 'Update your profile'
    fill_in 'Name', with: ''
    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: ''
    click_button 'Save changes'
    expect(page).to have_content 'Update your profile'
  end

  it 'successful edit friendly forwarding' do
    visit edit_user_path(@user)
    fill_in 'Email', with: 'michael@example.com'
    fill_in 'Password', with: 'password'
    click_button "Log in"
    expect(page).to have_current_path edit_user_path(@user)
    visit edit_user_path(@user)
    expect(page).to have_content 'Update your profile'
    fill_in 'Name', with: 'Foo Bar'
    fill_in 'Email', with: 'foo@bar.com'
    fill_in 'Password', with: 'foobar'
    fill_in 'Password confirmation', with: 'foobar'
    click_button 'Save changes'
    expect(page).to have_content 'Profile updated'
    expect(page).to  have_content 'Foo Bar'
    @user.reload
    expect(@user.name).to eq 'Foo Bar' 
    expect(@user.email).to eq 'foo@bar.com'
  end  
end
