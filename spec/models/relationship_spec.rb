require 'rails_helper'

RSpec.describe Relationship, type: :model do

  describe 'relationship validation' do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:relationships) { user.active_relationships.build(followed_id: other_user.id) }

    it 'relationshipsが有効' do
      expect(relationships.valid?).to be_truthy
    end

    it 'follower_idがnilの場合、有効ではなくなる' do
      relationships.follower_id = nil
      expect(relationships.valid?).not_to be_truthy
    end
  end
end
