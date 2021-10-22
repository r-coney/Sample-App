require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe 'account_activation' do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.account_activation(user) }

    describe 'account_activation_preview' do
      before do
        user.activation_token = User.new_token
        mail = UserMailer.account_activation(user)
      end

      it { expect(mail.subject).to eq("Account activation") }
      it { expect(mail.to).to eq([user.email]) }
      it {expect(mail.from).to eq(["noreply@example.com"]) }
    end

    describe 'renders the body' do
      subject { mail.body.encoded }

      it { is_expected.to match user.name }
      it { is_expected.to match user.activation_token }
      it { is_expected.to match CGI.escape(user.email) }
    end
  end
  
  describe 'password_reset' do
    let(:mail) { UserMailer.password_reset(user) }
    let(:user) { create(:user) }
    before { user.reset_token = User.new_token }
    
    describe 'renders the headers' do
      it { expect(mail.subject).to eq("Password reset") }
      it { expect(mail.to).to eq ([user.email]) }
      it { expect(mail.from).to eq(["noreply@example.com"]) }
    end
    
    describe 'renders the body' do
      subject { mail.body.encoded }
    
      it { is_expected.to match user.reset_token }
      it { is_expected.to match CGI.escape(user.email) }
    end
  end
end
  

