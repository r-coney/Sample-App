require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { attributes_for(:user) }
  before do
    @user = create(:user, :admin)
    @other_user = create(:user, :no_admin)
    ActionMailer::Base.deliveries.clear
  end
 
  describe '#new' do
    it "signupページが表示される" do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  describe '#edit' do
    it 'ログインしていなければ、#editが失敗する' do
      get edit_user_path(@user)
      expect(flash.empty?).not_to be_truthy
      expect(response).to redirect_to login_path
    end

    it '@other_userとしてログインした場合、#editが失敗する' do
      log_in_as(@other_user)
      get edit_user_path(@user)
      expect(flash.empty?).to be_truthy
      expect(response).to redirect_to root_url
    end
  end

  describe '#update' do
    it 'ログインしていなければ、#updateに失敗する' do
      patch user_path(@user), params: { user: { name: @user.name,
      email: @user.email } }
      expect(flash.empty?).not_to be_truthy
      expect(response).to redirect_to login_path
    end

    it '@other_userとしてログインした場合、#updateが失敗する' do
      log_in_as(@other_user)
      patch user_path(@user), params: { user: { name: @user.name,
      email: @user.email } }
      expect(flash.empty?).to be_truthy
      expect(response).to redirect_to root_url
    end
  end
  
  describe '#index' do
    it 'ログインしていなければ、#indexが失敗する' do
      get users_path
      expect(response).to redirect_to login_url
    end
  end

  describe 'admin' do
    it 'web経由でも@other_userにはadmin属性を編集できない' do
      log_in_as(@other_user)
      expect(@other_user.admin?).not_to be_truthy
      patch user_path(@other_user), params: {
      user: { password:              "password",
              password_confirmation: "password",
              admin: true } }
      @other_user.reload
      expect(@other_user.admin?).not_to be_truthy
    end
  end

  describe '#destroy' do
    it 'ログインしていなければ、#destroyが失敗する' do
      expect{ delete user_path(@user) }.not_to change { User.count }
      expect(response).to redirect_to login_url
    end

    it 'adminユーザーでなければ、#destroyは失敗する' do
      log_in_as(@other_user)
      expect{ delete user_path(@user)}.not_to change { User.count}
      expect(response).to redirect_to root_url
  end

    it 'adminユーザーであれば、#destroyに成功する' do
      log_in_as(@user)
      visit users_path
      expect{ delete user_path(@other_user) }.to change { User.count }.by -1
    end
  end

  describe 'account activation' do
    it "有効なサインアップ情報を持つ新規ユーザーにアクティベーションメールを送る" do
      aggregate_failures do
        expect do
          post users_path, params: { user: user }
        end.to change(User, :count).by(1)
        expect(ActionMailer::Base.deliveries.size).to eq(1)
        expect(response).to redirect_to root_url
        expect(is_logged_in?).to be_falsy
      end
    end
  end

  describe 'follow' do
    it 'ログインしていなければ、followingは表示れない' do
      get following_user_path(@user)
      expect(response).to redirect_to login_url
    end
  
    it 'ログインしていなければ、followersは表示されない' do
      get followers_user_path(@user)
      expect(response).to redirect_to login_url
    end
  end
end
