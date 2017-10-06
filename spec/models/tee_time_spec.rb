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

  before :each do
    Course.create(
      name: "Augusta National GC",
      description: "Home of the Masters",
      location: "Augusta, GA"
    )
  end

  let(:course) {
    Course.first
  }

  let(:user_attributes3) {user_attributes1.merge(username: "emmaB", email: "emma@gmail.com")}
  let(:user_attributes4) {user_attributes1.merge(username: "aryaS", email: "arya@gmail.com")}
  let(:user_attributes5) {user_attributes1.merge(username: "sansaS", email: "sansa@gmail.com")}

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

  context "users" do
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

    it "prevents duplicate users" do
      tee_time = TeeTime.create(time: Time.now)
      tee_time.build_course(name: "Augusta National GC")
      user1 = User.create(user_attributes1)
      tee_time.add_user(user1)
      tee_time.add_user(user1)
      expect(tee_time.user_tee_times.size).to eq(1)
      expect(tee_time.users.size).to eq(1)
    end

    it "prevents more than four users from joining" do
      tee_time = TeeTime.create(time: Time.now)
      tee_time.build_course(name: "Augusta National GC")
      user1 = User.create(user_attributes1)
      user2 = User.create(user_attributes2)
      user3 = User.create(user_attributes3)
      user4 = User.create(user_attributes4)
      user5 = User.create(user_attributes5)
      tee_time.add_user(user1)
      tee_time.add_user(user2)
      tee_time.add_user(user3)
      tee_time.add_user(user4)
      tee_time.add_user(user5)
      tee_time.save
      expect(tee_time.user_tee_times.size).to eq(4)
      expect(tee_time.users.size).to eq(4)
    end
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

  context "date_sort" do
    it "sorts tee times into chronological order" do
      user = User.create(user_attributes1)
      tee_time1 = course.tee_times.build(time: "8:00")
      tee_time2 = course.tee_times.build(time: "4:00")
      tee_time3 = course.tee_times.build(time: "6:00")
      tee_time1.add_user(user)
      tee_time2.add_user(user)
      tee_time3.add_user(user)
      tee_times = TeeTime.date_sort
      expect(tee_times).to eq([tee_time2, tee_time3, tee_time1])
    end
  end

end
