require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "#new" do
    it "ログインページが表示される" do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end
     
  describe '#create' do
    let!(:user) { create(:user) }
      it 'ログインしてユーザーページにリダイレクトし、その後ログアウトする' do
        post login_path, params: { session: { email: user.email,
                                              password: user.password } }
        expect(response).to redirect_to user_path(user)
        expect(is_logged_in?).to be_truthy 
        delete logout_path
        expect(response).to redirect_to root_path
        expect(is_logged_in?).not_to be_truthy
      end

      it 'ユーザーが複数のタブでログアウトしても、例外が発生しない' do
        delete logout_path
        aggregate_failures do
          expect(response).to redirect_to root_path
          expect(is_logged_in?).to be_falsy
        end
      end
  end
end
