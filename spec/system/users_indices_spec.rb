require 'rails_helper'

RSpec.describe "UsersIndices", type: :system do

include_context "setup"

  before do
    users
    @admin = create(:user, :michael)
    @non_admin = create(:user, :archer)
  end

  it 'index including pagination' do
    visit login_path
    fill_in 'Email', with: 'michael@example.com'
    fill_in 'Password', with: 'password'
    click_button "Log in"
    visit users_path
    expect(page).to have_content 'All users'
    expect(page).to have_content 'Previous'
    User.paginate(page: 1).each do |user|
      expect(page).to have_css("li", text: user.name)
    end
  end
end
