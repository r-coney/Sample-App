require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  describe "Relationships#create" do
    it "create should require logged-in user" do
      expect{ post relationships_path }.to change(Relationship, :count ).by(0)
      expect(response).to redirect_to login_url
    end
  end

  describe "Relationships#destroy" do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
    it 'destroy should require logged-in user' do
      expect{ delete relationship_path(other_user) }.to change(Relationship, :count).by(0)
      expect(response).to redirect_to login_url
    end 
  end
end
