require 'rails_helper'

RSpec.describe "MicropostsInterfaces", type: :system do
  let(:user) { create(:user) }
  let(:micropost) { create(:micropost, user_id: user.id) }
  let(:michael) { create(:user, :michael)}

  before do
    34.times do
      content = Faker::Lorem.sentence(word_count: 5)
      user.microposts.create!(content: content)
    end
  end

  scenario "micropost interface" do
    visit login_path
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
    click_on "Home"

    # 無効な送信
    click_on "Post"
    expect(has_css?('.alert-danger')).to be_truthy

    # 正しいページネーションリンク
    click_on "2"
    expect(URI.parse(current_url).query).to eq "page=2"

    # 有効な送信
    valid_content = "This micropost really ties the room together"
    fill_in "micropost_content", with: valid_content
    expect do
      click_on "Post"
      expect(current_path).to eq root_path
      expect(has_css?('.alert-success')).to be_truthy
    end.to change(Micropost, :count).by(1)

    # 投稿を削除する
    expect do
    expect(page).to have_selector 'a', text: "delete"
    click_on 'delete', match: :first
    expect(has_css?('.alert-success')).to be_truthy
    end.to change(Micropost, :count).by(-1)

    # 違うユーザのプロフィールにアクセス(削除リンクがないことを確認)
    visit user_path(michael)
    expect(page).not_to have_link "delete"
  end
end
