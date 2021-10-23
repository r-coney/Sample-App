 # spec/support/shared_context.rb
 RSpec.shared_context "setup" do

  # 遅延評価、呼ばれた時にDB保存される
  let(:users) { create_list(:user, 30) }

end