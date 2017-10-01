require 'rails_helper'

RSpec.describe User, type: :model do

  let(:attributes) do {
      username: "tylerB",
      email: "tyler@gmail.com",
      password: "123456",
      password_confirmation: "123456"
    }
  end

  let(:invalid_username_format) {attributes.merge(username: "#$&(SDF")}
  let(:missing_username) {attributes.except(:username)}
  let(:taken_username) {attributes.merge(username: "jonS")}

  describe "username" do
    it "is valid with a valid username" do
      expect(User.new(attributes)).to be_valid
    end

    it "is invalid with missing username" do
      expect(User.new(missing_username)).to_not be_valid
    end

    it "is invalid with taken username" do
      User.create(username: "jonS", email: "jon@gmail.com", password: "123456", password_confirmation: "123456")
      expect(User.new(taken_username)).to_not be_valid
    end

    it "is invalid with invalid format" do
      expect(User.new(invalid_username_format)).to_not be_valid
    end
  end

  # it "has a valid email" do
  #   expect(user.email).to_not be_nil
  # end

  # it "has a secure password" do
  #   password1 = "123456"
  #   password2 = "abcdef"
  #   expect(user.authenticate(password1)).to be_truthy
  #   expect(user.authenticate(password2)).to be_falsey
  # end
end