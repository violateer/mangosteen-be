require "rails_helper"

RSpec.describe User, type: :model do
  it "have email" do
    user = User.new email: "xx@xx.com"
    expect(user.email).to eq "xx@xx.com"
  end
end
