require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  describe '#create' do
    it 'ログインしていなければ、#createに失敗する' do
      expect{ post relationships_path }.to change(Relationship, :count ).by(0)
      expect(response).to redirect_to login_url
    end
  end

  describe '#destroy' do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
    it 'ログインしていなければ、#destroyに失敗する' do
      expect{ delete relationship_path(other_user) }.to change(Relationship, :count).by(0)
      expect(response).to redirect_to login_url
    end 
  end
end
