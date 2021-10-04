require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SessionsHelper, type: :helper do
  describe 'persistent session test' do
    before(:each) do
      @user = create(:user)
      remember(@user)
    end
    
    it 'current_user returns right user when session is nil' do
      expect(@user).to eq current_user
      expect(is_logged_in?).to be_truthy
    end

    it 'current_user returns nil when remember digest is wrong' do
      @user.update_attribute(:remember_digest, User.digest(User.new_token))
      expect(current_user.nil?).to be_truthy
    end
  end
end
