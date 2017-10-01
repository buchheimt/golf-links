require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {
    User.create(
      username: "tylerb",
      email: "tyler@gmail.com",
      password: "123456"
    )
  }

  it "has a username" do
    expect(user.username).to_not be_nil
  end

  it "has a email" do
    expect(user.email).to_not be_nil
  end

  it "has a password" do
    expect(user.password).to_not be_nil
  end
end