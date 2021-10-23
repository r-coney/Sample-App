require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  describe "Microposts#create" do
    let(:micropost) { attributes_for(:micropost ) }
    let(:post_request) { post microposts_path, params: { micropost: micropost } }
   
    it 'ログインしていないとmicropostを作成できない' do
      expect { post_request }.to change(Micropost, :count).by(0)
    end
  end

  describe 'Microposts#destroy' do
    let!(:micropost) { create(:micropost) }
    let(:delete_request) { delete micropost_path(micropost) }

    context 'ログインしていない時' do
      it "micropostが消去されない" do
        expect { delete_request }.to change(Micropost, :count).by(0)
      end

      it 'login_urlにリダイレクトされる' do
        expect(delete_request).to redirect_to login_url
      end
    end

    context 'ログインしている時' do
      let(:user) { create(:user, :other_user) }

      before { log_in_as(user) }

      it '他のユーザーのmicropostを消去しようとした時、root_urlにリダイレクトする' do
        expect{ delete_request }.to change(Micropost, :count).by (0)
        expect(delete_request).to redirect_to root_url
      end
    end
  end
end


