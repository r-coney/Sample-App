require 'rails_helper'

RSpec.describe "UsersSignups", type: :system do

  scenario 'invalid signup information' do
    visit signup_path
    fill_in 'Name', with: ' '
    fill_in 'Email', with: 'user@invalid'
    fill_in 'Password', with: 'foo'
    fill_in 'Password confirmation', with: 'bar'
    click_on 'Create my account'
    aggregate_failures do
      expect(current_path).to eq users_path
      expect(page).to have_content 'Sign up'
      expect(page).to have_content 'The form contains 4 errors'
    end
  end

  scenario 'valid signup information' do
    visit signup_path
    fill_in 'Name', with: 'User'
    fill_in 'Email', with: 'user@invalid.org'
    fill_in 'Password', with: 'foobar'
    fill_in 'Password confirmation', with: 'foobar'
    click_on 'Create my account'
    #  redirect_to @user
    #  expect(page).to have_content 'Welcome to the More Beauty!'
  end
end
