require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:micropost) { FactoryBot.create(:micropost) }

  it 'should be valid' do
    expect(micropost.valid?).to be_truthy
  end
  
  it 'user id should be present' do
    micropost.user_id = nil
    expect(micropost.valid?).not_to be_truthy
  end
  
  it 'content should be present' do
    micropost.content = ' '
    expect(micropost.valid?).not_to be_truthy
  end
  
  it 'content shoud be at most 140 characters' do
    micropost.content = "a" * 141
    expect(micropost.valid?).not_to be_truthy
  end
  
  describe "Sort by latest" do
      let!(:micropost) { create(:micropost) }
      let!(:day_before_yesterday) { create(:micropost, :day_before_yesterday, user_id: micropost.user_id) }
      let!(:now) { create(:micropost, :now, user_id: micropost.user_id) }
      let!(:yesterday) { create(:micropost, :yesterday, user_id: micropost.user_id) }
      
    it "succeeds" do
      expect(Micropost.first).to eq now
    end
  end
end
