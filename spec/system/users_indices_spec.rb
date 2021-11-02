require 'rails_helper'

RSpec.describe 'UsersIndices', type: :system do
  let!(:users) { create_list(:user, 30) }
  let(:user) { create(:user) }

  it 'indexページにpaginationリンクが存在している' do
    signin(user)
    visit users_path
    expect(page).to have_content "All users"
    expect(page).to have_content "Previous"
    User.paginate(page: 1).each do |user|
      expect(page).to have_css("li", text: user.name)
    end
  end
end
