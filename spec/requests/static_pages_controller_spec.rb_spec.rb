require 'rails_helper'

RSpec.describe "Access to static_pages", type: :request do
  before do
    @base_title = "More Beauty"
  end
  context 'GET home' do
    it 'should get home' do
      visit root_path
      expect(page).to have_title "#{@base_title}"
    end
  end

  context 'GET help' do
    it 'should get help' do
      visit help_path
      expect(page).to have_title "Help | #{@base_title}"
    end
  end

  context 'GET about' do
    it 'should get about' do
      visit about_path 
      expect(page).to have_title "About | #{@base_title}"
    end
  end

  context 'GET contact' do
    it 'should get contact' do
      visit contact_path
      expect(page).to have_title "Contact | #{@base_title}"
    end
  end

  context 'GET privacy_policy' do
    it 'should get privacy_policy' do
      visit privacy_policy_path
      expect(page).to have_title "privacy_policy | #{@base_title}"
    end
  end
end

