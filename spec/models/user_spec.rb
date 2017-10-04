require 'rails_helper'

RSpec.describe User, type: :model do

  let(:attributes) do {
      username: "tylerB",
      email: "tyler@gmail.com",
      password: "123456",
      password_confirmation: "123456",
      pace: 3,
      experience: 8,
      image: "image.jpg",
      role: 1
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
  let(:missing_pace) {attributes.except(:pace)}
  let(:invalid_pace1) {attributes.merge(pace: "apple")}
  let(:invalid_pace2) {attributes.merge(pace: 99)}
  let(:missing_experience) {attributes.except(:experience)}
  let(:invalid_experience1) {attributes.merge(experience: "apple")}
  let(:invalid_experience2) {attributes.merge(experience: 99)}
  let(:missing_image) {attributes.except(:image)}
  let(:missing_role) {attributes.except(:role)}

  it "has many UserTeeTimes" do
    user = User.create(attributes)
    user_tee_time1 = user.user_tee_times.build(tee_time_id: 1)
    user_tee_time2 = user.user_tee_times.build(tee_time_id: 2)
    expect(user.user_tee_times.size).to eq(2)
    expect(user.user_tee_times.first).to eq(user_tee_time1)
    expect(user.user_tee_times.last).to eq(user_tee_time2)
  end

  it "has many TeeTimes through UserTeeTimes" do
    user = User.create(attributes)
    user_tee_time1 = user.user_tee_times.build(tee_time_id: 1)
    tee_time1 = user_tee_time1.build_tee_time(time: Time.now)
    tee_time1.build_course(name: "Augusta National GC")
    user_tee_time2 = user.user_tee_times.build(tee_time_id: 2)
    tee_time2 = user_tee_time2.build_tee_time(time: Time.now)
    tee_time2.build_course(name: "Pebble Beach Golf Links")
    user_tee_time1.save
    user_tee_time2.save
    expect(user.tee_times.size).to eq(2)
    expect(user.tee_times.first).to eq(tee_time1)
    expect(user.tee_times.last).to eq(tee_time2)
  end

  it "has many Courses through TeeTimes" do
    user = User.create(attributes)
    user_tee_time1 = user.user_tee_times.build(tee_time_id: 1)
    tee_time1 = user_tee_time1.build_tee_time(time: Time.now)
    course1 = tee_time1.build_course(name: "Augusta National GC")
    user_tee_time2 = user.user_tee_times.build(tee_time_id: 2)
    tee_time2 = user_tee_time2.build_tee_time(time: Time.now)
    course2 = tee_time2.build_course(name: "Pebble Beach Golf Links")
    user_tee_time1.save
    user_tee_time2.save
    expect(user.courses.size).to eq(2)
    expect(user.courses.first).to eq(course1)
    expect(user.courses.last).to eq(course2)
  end

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

  describe "pace" do
    it "is assignable" do
      expect(User.new(attributes).pace).to eq(3)
    end

    it "is optional" do
      expect(User.new(missing_pace)).to be_valid
    end

    it "is only valid with an integer 1-10" do
      expect(User.new(invalid_pace1)).to_not be_valid
      expect(User.new(invalid_pace2)).to_not be_valid
    end
  end

  describe  "experience" do
    it "is assignable" do
      expect(User.new(attributes).experience).to eq(8)
    end

    it "is optional" do
      expect(User.new(missing_experience)).to be_valid
    end

    it "is only valid with an integer 1-10" do
      expect(User.new(invalid_experience1)).to_not be_valid
      expect(User.new(invalid_experience2)).to_not be_valid
    end
  end

  describe  "image" do
    it "is assignable" do
      expect(User.new(attributes).image).to eq("image.jpg")
    end

    it "is optional" do
      expect(User.new(missing_image)).to be_valid
    end
  end

  describe "role" do
    it "is assignable" do
      expect(User.new(attributes).role).to eq("owner")
    end

    it "is optional" do
      expect(User.new(missing_role)).to be_valid
    end

    it "defaults to 'user'" do
      expect(User.new(missing_role).role).to eq("user")
    end
  end
end
