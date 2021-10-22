require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  
  describe 'user validation' do
    it 'userが有効' do
      expect(user).to be_valid
    end

    it 'nameが空の場合は無効' do
      user.name = " "
      expect(user).not_to be_valid
    end

    it 'emailが空の場合は無効' do
      user.email = " "
      expect(user).not_to be_valid
    end

    it 'nameが50文字を超える場合は無効' do
      user.name = "a" * 51
      expect(user).not_to be_valid
    end

    it 'emailが長すぎる場合は無効' do
      user.email = "a" * 244 + "@example.com"
      expect(user).not_to be_valid
    end

    it 'email無効なメールアドレスは登録できない' do
      invalid_addresses = %w[user@example,com user_at_foo.org user.      name@example.foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user).not_to be_valid, "#{invalid_address.inspect} should be invalid"
      end
    end

    it 'emailが一意ではない場合は無効' do
      duplicate_user = user.dup
      user.save
      expect(duplicate_user).not_to be_valid
    end

    it 'emailは小文字で保存する' do
      mixed_case_email = 'Foo@ExAMPle.CoM'
      user.email = mixed_case_email
      user.save
      expect(user.email).to eq mixed_case_email.downcase
    end

    it 'passwordが空文字の場合は無効' do
      user.password = user.password_confirmation = " " * 6
      expect(user).not_to be_valid
    end

    it 'passwordは6文字未満の場合は無効' do
      user.password = user.password_confirmation =  "a" * 5
      expect(user).not_to be_valid
    end
  end

  describe '#authenticated' do
    it 'authenticated?は:rememberがnilの時、falseを返す' do
      expect(user.authenticated?(:remember, '')).not_to be_truthy
    end
  end

  describe 'associated microposts' do
    it 'userを削除するとmicropostも削除される' do
      user.save
      user.microposts.create!(content: "Lorem ipsum")
      expect{ user.destroy }.to change{ Micropost.count } .by -1
    end
  end

  describe 'follow & unfollow' do
    it 'userはother_userをフォローしていない' do
      expect(user.following?(other_user)).not_to be_truthy
    end

    it 'userがother_userをフォローした後、フォロー解除する'do
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy
      expect(other_user.followers.include?(user)).to be_truthy
      user.unfollow(other_user)
      expect(user.following?(other_user)).not_to be_truthy
    end
  end

  describe '#feed' do
    let(:user) { create(:user, :with_microposts) }
    let(:other_user) { create(:user, :with_microposts) }

    context 'userがother_userをフォローしている場合' do
      before { user.active_relationships.create!(followed_id: other_user.id) }

      it "userのmicropostにother_userのmicropostが含まれている" do
        other_user.microposts.each do |post_following|
          expect(user.feed.include?(post_following)).to be_truthy
        end
      end

      it "userのmicropostにuser自身のmicropostが含まれている" do
        user.microposts.each do |post_self|
          expect(user.feed.include?(post_self)).to be_truthy
        end
      end
    end

      context "userがother_userをフォローしていない場合" do
        it "userのmicropostにother_userのmicropostが含まれていない" do
          other_user.microposts.each do |post_unfollowed|
            expect(user.feed.include?(post_unfollowed)).to be_falsy
          end
        end
      end
  end
end
