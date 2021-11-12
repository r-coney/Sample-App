require 'rails_helper'

RSpec.describe 'MicropostsInterfaces', type: :system do
  let(:user) { create(:user) }
  let(:micropost) { create(:micropost, user_id: user.id) }
  let(:other_user) { create(:user)}

  before do
    34.times do
      content = Faker::Lorem.sentence(word_count: 5)
      user.microposts.create!(content: content)
    end
  end
  
  describe "micropost interface" do
  before do 
    signin(user)
    click_on "ホーム"
  end

    it '無効な送信の場合、micropostは作成できない' do 
      click_on "投稿"
      expect(has_css?('.alert-danger')).to be_truthy
    end

    it '正しいページネーションリンクが存在する' do 
      click_on "2"
      expect(URI.parse(current_url).query).to eq "page=2"
    end

    it '有効な送信の場合は、micropostを作成できる' do 
      valid_content = "This micropost really ties the room together"
      fill_in "micropost_content", with: valid_content
      expect do
        click_on "投稿"
        expect(current_path).to eq root_path
        expect(has_css?('.alert-success')).to be_truthy
      end.to change(Micropost, :count).by(1)
    end

    it '投稿を消去する' do 
      expect do
        expect(page).to have_selector 'a', text: "delete"
        click_on 'delete', match: :first
        expect(has_css?('.alert-success')).to be_truthy
      end.to change(Micropost, :count).by(-1)
    end

    it '違うユーザーのプロフィールにdeleteリンクがないことを確認' do
      visit user_path(other_user)
      expect(page).not_to have_link "delete"
    end
  end
end
