require 'rails_helper'

RSpec.describe UserTeeTime, type: :model do

  let(:user_attributes) do {
      username: "tylerB",
      email: "tyler@gmail.com",
      password: "123456",
      password_confirmation: "123456"
    }
  end

  it "belongs to a User" do
    user_tee_time = UserTeeTime.create(tee_time_id: 1)
    user = User.create(user_attributes)
    user_tee_time.user = user
    expect(user_tee_time.user).to eq(user)
  end

  it "belongs to a TeeTime" do
    user_tee_time = UserTeeTime.create()
    tee_time = user_tee_time.build_tee_time(time: Time.now)
    expect(user_tee_time.tee_time).to eq(tee_time)
  end

  it "belongs to a Course through a TeeTime" do
    user_tee_time = UserTeeTime.create()
    tee_time = user_tee_time.build_tee_time(time: Time.now)
    course = tee_time.build_course(name: "new course")
    expect(user_tee_time.course).to eq(course)
  end

  context "#guest_count" do
    it "is assignable with a number between 0 and 3" do
      user_tee_time = UserTeeTime.create(guest_count: 1)
      user_tee_time.build_tee_time(time: Time.now)
      user_tee_time.build_user(user_attributes)
      expect(user_tee_time.guest_count).to eq(1)
      expect(user_tee_time).to be_valid
    end

    it "is invalid with wrong number" do
      user_tee_time = UserTeeTime.create(guest_count: 8)
      user_tee_time.build_tee_time(time: Time.now)
      user_tee_time.build_user(user_attributes)
      expect(user_tee_time).to_not be_valid
    end

    it "is invalid with a non-integer" do
      user_tee_time = UserTeeTime.create(guest_count: "apple")
      user_tee_time.build_tee_time(time: Time.now)
      user_tee_time.build_user(user_attributes)
      expect(user_tee_time).to_not be_valid
    end
  end
end
