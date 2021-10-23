require 'rails_helper'

RSpec.describe "AccountActivations", type: :request do
  let(:user) { create(:user, :no_activated) }

  context '正しいトークンと間違ったemailの場合' do
    before do
      get edit_account_activation_path(
        user.activation_token,
        email: 'wrong',
      )
    end

    it 'ログイン失敗' do
      expect(is_logged_in?).to be_falsy
      expect(response).to redirect_to root_url
    end
  end

  context '間違ったトークンと正しいemailの場合' do
    before do
      get edit_account_activation_path(
        'wrong',
        email: user.email,
      )
    end

    it 'ログイン失敗' do
      expect(is_logged_in?).to be_falsy
      expect(response).to redirect_to root_url
    end
  end

  context 'トークン、emailが両方正しい場合' do
    before do
      get edit_account_activation_path(
        user.activation_token,
        email: user.email,
      )
    end

    it 'ログイン成功' do
      expect(is_logged_in?).to be_truthy
      expect(response).to redirect_to user
    end
  end
end