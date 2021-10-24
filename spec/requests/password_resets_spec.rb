require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let(:user) { create(:user) }

  before { user.create_reset_digest }

  describe '#new' do
    it 'password_resetページを表示する' do
      get "/password_resets/new"
      aggregate_failures do
      expect(response).to have_http_status(:success)
      expect(response.body).to include "Forgot password"
      end
    end
  end

  describe "#create" do
    context 'メールアドレスが無効な時' do
      it 'createに失敗する' do
        post password_resets_path, params: { password_reset: { email: "" } }
        aggregate_failures do
          expect(response).to have_http_status(200)
         expect(response.body).to include 'Forgot password'
        end
      end
    end

    context 'メールアドレスが有効な時' do
      it 'createに成功する' do
        post password_resets_path, params: { password_reset: { email: user.email } }
        aggregate_failures do
          expect(user.reset_digest).not_to eq user.reload.reset_digest
          expect(ActionMailer::Base.deliveries.size).to eq 1
          expect(response).to redirect_to root_url
        end
      end
    end
  end

  describe '#edit' do
    context 'メールアドレスが無効な時' do
      before { get edit_password_reset_path(user.reset_token, email: ' ') }
      it '#editが失敗する' do
        expect(response).to redirect_to root_url
      end
    end

    context '無効なユーザーの時' do
      before do
        user.toggle!(:activated)
        get edit_password_reset_path(user.reset_token, email: user.email)
      end

      it '#editが失敗する' do
        expect(response).to redirect_to root_url
      end
    end

    # メールアドレスが有効で、トークンが無効
    context 'メールアドレスが有効で、トークンが無効な時' do
      before { get edit_password_reset_path("wrong", email: user.email) }

      it '#editが失敗する' do
        expect(response).to redirect_to root_url
      end
    end

    
    context 'メールアドレスもトークンも有効な時' do
      before { get edit_password_reset_path(user.reset_token, email: user.email) }
       
      it '#editが成功する' do
        aggregate_failures do
          expect(response).to  have_http_status(200)
          expect(response.body).to include "Reset password"
        end
      end
    end

    describe '#update' do

      context "無効なパスワードの時" do
        before do
          patch password_reset_path(user.reset_token),
                params: { email: user.email,
                          user: {password: "foobaz",
                                password_confirmation: "barquux", }, }
        end
  
        it '#updateが失敗する' do
          aggregate_failures do
            expect(response).to have_http_status(200)
            expect(response.body).to include "Reset password"
          end
        end
      end
  
      # パスワードが空
      context 'パスワードが空の時' do
        before do
          patch password_reset_path(user.reset_token),
                params: {
                  email: user.email,
                  user: {
                    password: "",
                    password_confirmation: "",
                  },
                }
        end
  
        it '#updateが失敗する' do
          aggregate_failures do
            expect(response).to have_http_status(200)
            expect(response.body).to include "Reset password"
          end
        end
      end
  
      # 有効なパスワードとパスワード確認
      context '有効なパスワードの時' do
        before do
          patch password_reset_path(user.reset_token),
                params: {
                  email: user.email,
                  user: {
                    password: "foobaz",
                    password_confirmation: "foobaz",
                  },
                }
        end
  
        it '#updateが成功する' do
          aggregate_failures do
            expect(is_logged_in?).to be_truthy
            expect(user.reload.reset_digest).to eq nil
            expect(response).to redirect_to user
          end
        end
      end
    end
  end

  describe '#check_expiration' do
    context "userが3時間後にupdateした時" do
      before do
        user.update_attribute(:reset_sent_at, 3.hours.ago)
        patch password_reset_path(user.reset_token),
              params: {
                email: user.email,
                user: {
                  password: "foobar",
                  password_confirmation: "foobar",
                },
              }
      end

      it '#updateが失敗する' do
        expect(response).to redirect_to new_password_reset_url
      end
    end
  end
end
