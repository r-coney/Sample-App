require 'rails_helper'

RSpec.describe "Access to static_pages", type: :request do
  before { @base_title = "Sample App" }

  describe '#home' do
    it 'homeページが表示される' do
      visit root_path
      expect(page).to have_title "#{@base_title}"
    end
  end

  describe '#help' do
    it 'helpページが表示される' do
      visit help_path
      expect(page).to have_title "Help | #{@base_title}"
    end
  end

  describe '#about' do
    it 'aboutページが表示される' do
      visit about_path 
      expect(page).to have_title "About | #{@base_title}"
    end
  end

  describe '#contact' do
    it 'contactページが表示される' do
      visit contact_path
      expect(page).to have_title "Contact | #{@base_title}"
    end
  end
end

