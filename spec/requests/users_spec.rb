require 'rails_helper'

RSpec.describe "Users", type: :request do
 describe 'GET #new' do
  before do
    @user = create(:user, :michael)
    @other_user = create(:user, :archer)
  end
  
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:success)
    end

    it 'should redirect edit when not logged in' do
      get edit_user_path(@user)
      expect(flash.empty?).not_to be_truthy
      expect(response).to redirect_to login_path
    end

    it 'should redirect update when not logged' do
      patch user_path(@user), params: { user: { name: @user.name,
      email: @user.email } }
      expect(flash.empty?).not_to be_truthy
      expect(response).to redirect_to login_path
    end

    it 'should redirect edit when logged in as wrong user' do
      log_in_as(@other_user)
      get edit_user_path(@user)
      expect(flash.empty?).to be_truthy
      expect(response).to redirect_to root_url
    end

    it 'should redirect update when  logged in as wrong user' do
      log_in_as(@other_user)
      patch user_path(@user), params: { user: { name: @user.name,
      email: @user.email } }
      expect(flash.empty?).to be_truthy
      expect(response).to redirect_to root_url
    end

    it 'should redirect index when not logged in' do
      get users_path
      expect(response).to redirect_to login_url
    end

    it 'should not allow the admin attribute to be edited via the web' do
      log_in_as(@other_user)
      expect(@other_user.admin?).not_to be_truthy
      patch user_path(@other_user), params: {
        user: { password:              "password",
                password_confirmation: "password",
                admin: true } }
      @other_user.reload
      expect(@other_user.admin?).not_to be_truthy
    end

    it 'should redirect destroy when not logged in' do
      expect{ delete user_path(@user) }.not_to change { User.count }
      expect(response).to redirect_to login_url
    end

    it 'should redirect destroy when logged in as a non-admin' do
      log_in_as(@other_user)
      expect{ delete user_path(@user)}.not_to change { User.count}
      expect(response).to redirect_to root_url
    end

    

    it 'succeds when user is administrator' do
      log_in_as(@user)
      visit users_path
      expect{ delete user_path(@other_user) }.to change { User.count }.by -1
      expect(response).to redirect_to users_url
    end
  end
end
