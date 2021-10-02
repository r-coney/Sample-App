require 'rails_helper'

RSpec.describe "UsersLogins", type: :system do
  before do
    @user = create(:user, :michael)
  end

  scenario 'login with valid email/invalid password' do
    visit login_path
    expect(page).to have_content 'Log in'
    fill_in 'Email', with: 'michael@example.com'
    fill_in 'Password', with: 'invalid'
    click_button "Log in"
    expect(page).to have_content 'Log in'
    visit root_path
    expect(page).not_to have_content 'Invalid email/password combination'
  end

  scenario 'login with invalid information' do
    visit login_path
    expect(page).to have_content 'Log in'
    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    click_button "Log in"
    expect(page).to have_content 'Log in'
    visit root_path
    expect(page).not_to have_content 'Invalid email/password combination'
  end

  scenario 'login with valid information' do
    visit login_path
    fill_in 'Email', with: 'michael@example.com'
    fill_in 'Password', with: 'password'
    click_button "Log in"
    expect(page).to have_current_path user_path(@user)
    expect(page).not_to have_link login_path
    click_link 'Account'
    expect(page).to have_link 'profile', href: user_path(@user)
    expect(page).to have_link 'Log out', href: logout_path
  end

  scenario 'log out after log in' do
    visit login_path
    fill_in 'Email', with: 'michael@example.com'
    fill_in 'Password', with: 'password'
    click_button "Log in"
    click_link 'Account'
    click_link 'Log out'
    expect(page).to have_current_path root_path
    expect(page).to have_link 'Log in', href: login_path
    expect(page).not_to have_link 'Account'
    expect(page).not_to have_link nil, href: logout_path
    expect(page).not_to have_link nil, href: user_path(@user)
  end


end
