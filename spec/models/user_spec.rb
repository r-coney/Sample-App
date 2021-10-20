require 'rails_helper'

RSpec.describe User, type: :model do
  
  context 'User.new' do
    let(:michael) { create(:user, :michael) }
    let(:archer) { create(:user, :archer) }

    before(:each) do
      @user = create(:user)
    end

    it 'should be valid' do
      expect(@user).to be_valid
    end

    it 'name should be present' do
      @user.name = " "
      expect(@user).not_to be_valid
    end

    it 'email should be present' do
      @user.email = " "
      expect(@user).not_to be_valid
    end

    it 'name should not be too long' do
      @user.name = "a" * 51
      expect(@user).not_to be_valid
    end

    it 'email should not be too long' do
      @user.email = "a" * 244 + "@example.com"
      expect(@user).not_to be_valid
    end

    it 'email validation should reject invalid addresses' do
      invalid_addresses = %w[user@example,com user_at_foo.org user.      name@example.foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      expect(@user).not_to be_valid, "#{invalid_address.inspect} should be invalid"
      end
    end

    it 'email addresses should be unique' do
      duplicate_user = @user.dup
      @user.save
      expect(duplicate_user).not_to be_valid
    end

    it 'email addresses should be saved as lower-case' do
      mixed_case_email = 'Foo@ExAMPle.CoM'
      @user.email = mixed_case_email
      @user.save
      expect(@user.email).to eq mixed_case_email.downcase
    end

    it 'password should be present (nonblank)' do
      @user.password = @user.password_confirmation = " " * 6
      expect(@user).not_to be_valid
    end

    it 'password should have a minimum length' do
      @user.password = @user.password_confirmation =  "a" * 5
      expect(@user).not_to be_valid
    end

    it 'authenticated? should return false for a user with nil digest' do
      expect(@user.authenticated?(:remember, '')).not_to be_truthy
    end

    it 'associated microposts should be destroyed' do
      @user.save
      @user.microposts.create!(content: "Lorem ipsum")
      expect{ @user.destroy }.to change{ Micropost.count } .by -1
    end

    it 'should follow and unfollow a user' do
      expect(michael.following?(archer)).not_to be_truthy
      michael.follow(archer)
      expect(michael.following?(archer)).to be_truthy
      expect(archer.followers.include?(michael)).to be_truthy
      michael.unfollow(archer)
      expect(michael.following?(archer)).not_to be_truthy
    end
  end

  describe "def feed" do
    let(:user) { create(:user, :with_microposts) }
    let(:other_user) { create(:user, :with_microposts) }

    context "when user is following other_user" do
      before { user.active_relationships.create!(followed_id: other_user.id) }

      it "contains other user's microposts within the user's Micropost" do
        other_user.microposts.each do |post_following|
          expect(user.feed.include?(post_following)).to be_truthy
        end
      end

      it "contains the user's own microposts in the user's Micropost" do
        user.microposts.each do |post_self|
          expect(user.feed.include?(post_self)).to be_truthy
        end
      end
    end

      context "when user is not following other_user" do
        it "doesn't contain other user's microposts within the user's Micropost" do
          other_user.microposts.each do |post_unfollowed|
            expect(user.feed.include?(post_unfollowed)).to be_falsy
          end
        end
      end
  end
end
