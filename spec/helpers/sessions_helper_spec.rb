require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  describe 'persistent session test' do
    let(:user) { create(:user) }
    before { remember(user) }
    
    it 'current_userはセッションがnil場合、正しいユーザーを返す' do
      expect(user).to eq current_user
      expect(is_logged_in?).to be_truthy
    end

    it 'remember_digestが一致しない場合、nilを返す' do
      user.update_attribute(:remember_digest, User.digest(User.new_token))
      expect(current_user.nil?).to be_truthy
    end
  end
end
