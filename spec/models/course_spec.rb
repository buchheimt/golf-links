require 'rails_helper'

RSpec.describe Course, type: :model do

  let(:attributes) do {
      name: "Augusta National GC",
      description: "Home of the Masters",
      location: "Augusta, GA"
    }
  end

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

  let(:missing_name) {attributes.except(:name)}

  it "has many TeeTimes" do
    course = Course.new(attributes)
    tee_time1 = course.tee_times.build(time: Time.now)
    tee_time2 = course.tee_times.build(time: Time.now)
    expect(course.tee_times.size).to eq(2)
    expect(course.tee_times.first).to eq(tee_time1)
    expect(course.tee_times.last).to eq(tee_time2)
  end

  it "has many UserTeeTimes through TeeTimes" do
    course = Course.new(attributes)
    tee_time1 = course.tee_times.build(time: Time.now)
    user_tee_time1 = tee_time1.user_tee_times.build()
    user1 = user_tee_time1.build_user(user_attributes1)
    tee_time2 = course.tee_times.build(time: Time.now)
    user_tee_time2 = tee_time2.user_tee_times.build()
    user2 = user_tee_time2.build_user(user_attributes2)
    user_tee_time1.save
    user_tee_time2.save
    expect(course.user_tee_times.size).to eq(2)
    expect(course.user_tee_times.first).to eq(user_tee_time1)
    expect(course.user_tee_times.last).to eq(user_tee_time2)
  end

  it "has many Users through UserTeeTimes" do
    course = Course.new(attributes)
    tee_time1 = course.tee_times.build(time: Time.now)
    user_tee_time1 = tee_time1.user_tee_times.build()
    user1 = user_tee_time1.build_user(user_attributes1)
    tee_time2 = course.tee_times.build(time: Time.now)
    user_tee_time2 = tee_time2.user_tee_times.build()
    user2 = user_tee_time2.build_user(user_attributes2)
    user_tee_time1.save
    user_tee_time2.save
    expect(course.users.size).to eq(2)
    expect(course.users.first).to eq(user1)
    expect(course.users.last).to eq(user2)
  end

  it "is valid with valid attributes" do
    expect(Course.new(attributes)).to be_valid
  end

  describe "name" do
    it "is invalid with missing name" do
      expect(Course.new(missing_name)).to_not be_valid
    end
  end
end
