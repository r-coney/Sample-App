require 'rails_helper'

RSpec.describe "UsersProfiles", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }

  before do
    34.times do
      content = Faker::Lorem.sentence(word_count: 5)
      user.microposts.create!(content: content)
    end
  end

  it 'profile display' do
    visit user_path(user)
    expect(page).to have_title full_title(user.name)
    expect(page).to have_selector 'h1', text: user.name
    expect(page).to have_selector 'h1>img.gravatar'
    expect(page).to have_content Micropost.count
    expect(page).to have_content user.following.count
    expect(page).to have_content user.followers.count
    expect(page).to have_selector 'div.pagination' 
    user.microposts.paginate(page: 1).each do |micropost|
      expect(page).to have_content micropost.content
    end
  end


end
    




