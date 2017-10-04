require 'rails_helper'

RSpec.describe TeeTime, type: :model do

  let(:user_attributes1) do {
      username: "tylerB",
      email: "tyler@gmail.com",
      password: "123456",
      password_confirmation: "123456"
    }
  end

  let(:user_attributes2) do {
      username: "jonS",
      email: "jon@gmail.com",
      password: "123456",
      password_confirmation: "123456"
    }
  end

  it "belongs to a Course" do
    tee_time = TeeTime.create(time: Time.now)
    course = tee_time.build_course(name: "test course")
    expect(tee_time.course).to eq(course)
  end

  it "has many UserTeeTimes" do
    tee_time = TeeTime.create(time: Time.now)
    user_tee_time1 = tee_time.user_tee_times.build()
    user_tee_time2 = tee_time.user_tee_times.build()
    expect(tee_time.user_tee_times.size).to eq(2)
    expect(tee_time.user_tee_times.first).to eq(user_tee_time1)
    expect(tee_time.user_tee_times.last).to eq(user_tee_time2)
  end

  it "has many Users through UserTeeTimes" do
    tee_time = TeeTime.create(time: Time.now)
    tee_time.build_course(name: "Augusta National GC")
    user_tee_time1 = tee_time.user_tee_times.build()
    user1 = user_tee_time1.build_user(user_attributes1)
    user_tee_time2 = tee_time.user_tee_times.build()
    user2 = user_tee_time2.build_user(user_attributes2)
    user_tee_time1.save
    user_tee_time2.save
    expect(tee_time.users.size).to eq(2)
    expect(tee_time.users.first).to eq(user1)
    expect(tee_time.users.last).to eq(user2)
  end

  context "time" do
    it "is invalid with missing time" do
      tee_time = TeeTime.create()
      course = tee_time.build_course(name: "test course")
      expect(tee_time).to_not be_valid
    end

    it "is invalid with incorrect time format" do
      tee_time = TeeTime.create(time: "apple")
      course = tee_time.build_course(name: "test course")
      expect(tee_time).to_not be_valid
    end
  end

end
