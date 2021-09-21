require 'rails_helper'

RSpec.describe "Access to static_pages", type: :request do
  before do
    @base_title = "More Beauty"
  end
  context 'GET home' do
    it 'should get home' do
      visit '/'
      expect(page).to have_title "Home | #{@base_title}"
    end
  end

  context 'GET help' do
    it 'should get help' do
      visit '/static_pages/help'
      expect(page).to have_title "Help | #{@base_title}"
    end
  end

  context 'GET about' do
    it 'should get about' do
      visit '/static_pages/about' 
      expect(page).to have_title "About | #{@base_title}"
    end
  end

  context 'GET about' do
    it 'should get contact' do
      visit '/static_pages/contact'
      expect(page).to have_title "Contact | #{@base_title}"
    end
  end
end