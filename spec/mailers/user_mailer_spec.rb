require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:user) { create(:user, :michael) }
    let(:mail) { UserMailer.account_activation(user) }
    it "account_activation_preview" do
      user.activation_token = User.new_token
      mail = UserMailer.account_activation(user)
      expect(mail.subject).to eq("Account activation")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match user.name
      expect(mail.body.encoded).to match user.activation_token
      expect(mail.body.encoded).to match CGI.escape(user.email)
    end
  end
  
  describe "password_reset" do
    let(:mail) { UserMailer.password_reset(user) }
    let(:user) { create(:user, :michael) }
    
    it "renders the headers" do
      user.reset_token = User.new_token
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq ([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end
    
    it "renders the body" do
      user.reset_token = User.new_token
      expect(mail.body.encoded).to match user.reset_token
      expect(mail.body.encoded).to match CGI.escape(user.email)
      
    end
  end
end
  
