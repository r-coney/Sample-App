require 'rails_helper'

RSpec.describe "Followings", type: :system do
  let(:user) { create(:user)}
  let(:other_users) { create_list(:user, 20) }

  before do
    other_users[0..9].each do |other_user|
      user.active_relationships.create!(followed_id: other_user.id)
      user.passive_relationships.create!(follower_id: other_user.id)
    end
  end
  
  it 'following page' do
    visit login_path
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
    click_on "following"
    expect(user.following.count).to eq 10
    user.following.each do |u|
      expect(page).to have_link u.name, href: user_path(u)
    end

    click_on "followers"
    expect(user.followers.count).to eq 10
    user.followers.each do |u|
      expect(page).to have_link u.name, href: user_path(u)
    end
  end
end

