require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:micropost) { create(:micropost) }

  describe 'micropost validation' do
    it 'micropostが有効' do
    expect(micropost.valid?).to be_truthy
    end
  
    it 'user_idがnilの場合、有効ではなくなる' do
      micropost.user_id = nil
      expect(micropost.valid?).not_to be_truthy
    end
  
    it 'contentが空文字の場合、有効ではなくなる' do
      micropost.content = ' '
      expect(micropost.valid?).not_to be_truthy
    end
  
    it 'contentが140文字を超えると、有効ではなくなる' do
      micropost.content = "a" * 141
      expect(micropost.valid?).not_to be_truthy
    end
  end
  
  describe "Sort by latest" do
      let!(:day_before_yesterday) { create(:micropost, :day_before_yesterday) }
      let!(:now) { create(:micropost, :now) }
      let!(:yesterday) { create(:micropost, :yesterday) }
      
    it { expect(Micropost.first).to eq now }
  end
end
