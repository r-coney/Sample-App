require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'full_title' do
    context 'no argument' do
      it 'return [More Beauty]' do
        expect(full_title).to eq("More Beauty")
      end
    end
    context 'argument is "Help"' do
      it 'retun [Help | More Beauty]' do
        expect(full_title('Help')).to eq('Help | More Beauty')
      end
    end
  end
end
