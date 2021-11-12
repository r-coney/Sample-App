require 'rails_helper'

RSpec.describe "Followings", type: :system do
  let!(:user) { create(:user)}
  let!(:other_users) { create_list(:user, 20) }

  before do
    other_users[0..9].each do |other_user|
      user.active_relationships.create!(followed_id: other_user.id)
      user.passive_relationships.create!(follower_id: other_user.id)
    end
  end
  
  describe "following page" do
    before { signin(user) }

    context 'followingをクリックした時' do
      it 'フォローしているユーザーが表示される' do
        click_on "following"
        expect(user.following.count).to eq 10
        user.following.each do |u|
          expect(page).to have_link u.name, href: user_path(u)
        end
      end
    end

    context 'followersをクリックした時' do
      it 'フォロワーが表示される' do
        click_on "followers"
        expect(user.followers.count).to eq 10
        user.followers.each do |u|
          expect(page).to have_link u.name, href: user_path(u)
        end
      end
    end
  end

  describe 'follow unfollow' do
    before { signin(user) }
    
    context 'フォロー解除した時' do
      it 'ユーザーがフォロー解除すると、フォローの数が一つ減る' do
        visit user_path(other_users.first.id)
        expect do
          click_on "Unfollow"
          expect(page).not_to have_link "Unfollow"
          visit current_path
        end.to change(user.following, :count).by(-1)
      end
    end

    context 'フォローした時' do
      it 'ユーザーがフォローすると、フォローの数が一つ増える' do
        visit user_path(other_users.last.id)
        expect do
          click_on "Follow"
          expect(page).not_to have_link "Follow"
         visit current_path
        end.to change(user.following, :count).by(1)
      end
    end
  end

  describe 'feed' do
    it 'ホームページにフィードが表示される' do
      signin(user)
      click_on 'ホーム'
      user.feed.paginate(page: 1).each do |micropost|
        expect(page).to include CGI.escapeHTML(micropost.content), response.body
      end
    end
  end
end

