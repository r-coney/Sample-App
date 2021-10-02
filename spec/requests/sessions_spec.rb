require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end
     
  describe 'POST #create' do
    let!(:user) { create(:user) }
      it 'log in and redirect to detail page' do
        post login_path, params: { session: { email: user.email,
                                              password: user.password } }
        expect(response).to redirect_to user_path(user)
        expect(is_logged_in?).to be_truthy 
      end
  end

end
