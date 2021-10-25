require 'rails_helper'

RSpec.describe "UsersProfiles", type: :system do
  let(:user) { create(:user) }
  let(:micropost) { create(:micropost, user_id: user.id) }

  before do
    34.times do
      content = Faker::Lorem.sentence(word_count: 5)
      user.microposts.create!(content: content)
    end
  end

  subject { page }

  it 'profileのdisplayを確認' do
    visit user_path(user)
    is_expected.to have_title full_title(user.name)
    is_expected.to have_selector 'h1', text: user.name
    is_expected.to have_selector 'h1>img.gravatar'
    is_expected.to have_content Micropost.count
    is_expected.to have_content user.following.count
    is_expected.to have_content user.followers.count
    is_expected.to have_selector 'div.pagination' 
    user.microposts.paginate(page: 1).each do |micropost|
      expect(page).to have_content micropost.content
    end
  end
end
    




