require 'rails_helper'

module SigninHelper
  def signin(user)
    visit login_path
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: user.password
    click_button 'ログイン'
  end
end

RSpec.configure do |config|
  config.include SigninHelper
end