require 'rails_helper'

RSpec.describe User, type: :model do

  let(:attributes) do {
      username: "tylerB",
      email: "tyler@gmail.com",
      password: "123456",
      password_confirmation: "123456"
    }
  end

  let(:missing_username) {attributes.except(:username)}
  let(:taken_username) {attributes.merge(username: "jonS")}
  let(:invalid_username_format) {attributes.merge(username: "#$&(SDF")}
  let(:missing_email) {attributes.except(:email)}
  let(:taken_email) {attributes.merge(email: "jon@gmail.com")}
  let(:invalid_email_format) {attributes.merge(email: "asdfsd.asdf.ff")}
  let(:short_password) {attributes.merge(password: "12345", password_confirmation: "12345")}
  let(:missing_confirmation) {attributes.except(:password_confirmation)}
  let(:mismatch_confirmation) {attributes.merge(password_confirmation: "654321")}

  it "is valid with valid attributes" do
    expect(User.new(attributes)).to be_valid
  end

  describe "username" do
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

  describe "email" do
    it "is invalid with missing email" do
      expect(User.new(missing_email)).to_not be_valid
    end

    it "is invalid with taken email" do
      User.create(username: "jonS", email: "jon@gmail.com", password: "123456", password_confirmation: "123456")
      expect(User.new(taken_email)).to_not be_valid
    end

    it "is invalid with invalid format" do
      expect(User.new(invalid_email_format)).to_not be_valid
    end
  end

  describe "password" do
    it "is secure" do
      password2 = "abcdef"
      expect(User.new(attributes).authenticate(password2)).to be_falsey
    end

    it "is invalid with length less than 6" do
      expect(User.new(short_password)).to_not be_valid
    end

    it "is invalid without confirmation" do
      expect(User.new(missing_confirmation)).to_not be_valid
    end

    it "is invalid without matching confirmation" do
      expect(User.new(mismatch_confirmation)).to_not be_valid
    end
  end

  # it "has a secure password" do
  #   password1 = "123456"
  #   password2 = "abcdef"
  #   expect(user.authenticate(password1)).to be_truthy
  #   expect(user.authenticate(password2)).to be_falsey
  # end
end