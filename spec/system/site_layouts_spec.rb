require 'rails_helper'

RSpec.describe 'site layout', type: :system do
  context 'access to root_path' do
    before { visit root_path }
    subject { page }
    it 'has links sach as root_path, help_path and about_path' do
      is_expected.to have_link nil, href: root_path
      is_expected.to have_link 'Help', href: help_path
      is_expected.to have_link 'About', href: about_path
      is_expected.to have_link 'Contact', href: contact_path
      visit contact_path
      expect(page).to have_title full_title("Contact")
      visit signup_path
      expect(page).to have_title full_title("Sign up")
    end
  end
end