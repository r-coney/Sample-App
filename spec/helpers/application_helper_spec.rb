require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#full_title' do
    context '引数がない時' do
      it { expect(full_title).to eq("Sample App") }
    end
    context '引数が"Help"の時' do
      it { expect(full_title('Help')).to eq("Help | Sample App") }
    end
  end
end
