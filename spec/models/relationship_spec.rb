require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user) { create(:user) }
  let(:michael) { create(:user, :michael)}
  let(:relationships) { user.active_relationships.build(followed_id: michael.id) }

 it 'should be valid' do
  expect(relationships.valid?).to be_truthy
 end

 it 'should require a follower_id' do
  relationships.follower_id = nil
  expect(relationships.valid?).not_to be_truthy
 end

 it 'should require a followed_id' do
  relationships.followed_id = nil
  expect(relationships.valid?).not_to be_truthy
 end

end
