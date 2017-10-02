require_relative "../rails_helper.rb"

describe "Feature Test: TeeTime Add", type: :feature do

  before :each do
    User.create(
      username: "tylerB",
      email: "tyler@gmail.com",
      password: "123456",
      password_confirmation: "123456"
    )
  end

  before :each do
    Course.create(
      name: "Augusta National GC",
      description: "Home of the Masters",
      location: "Augusta, GA"
    )
  end

  let(:user) {
    User.first
  }

  let(:course) {
    Course.first
  }

  it "allows a user to create a new TeeTime" do
    visit new_user_tee_time_path(user)
    fill_in("tee_time[time]", with: Time.now)
    fill_in("tee_time[course_id]", with: course.id)
    click_button("Create Tee Time")
    expect(current_path).to eq(user_tee_time_path(user, TeeTime.first))
    expect(page).to have_content(course.name)
  end

end

describe "Feature Test: User/TeeTime Show", type: :feature do

  before :each do
    User.create(
      username: "tylerB",
      email: "tyler@gmail.com",
      password: "123456",
      password_confirmation: "123456"
    )
  end

  before :each do
    Course.create(
      name: "Augusta National GC",
      description: "Home of the Masters",
      location: "Augusta, GA"
    )
  end

  let(:user) {
    User.first
  }

  let(:course) {
    Course.first
  }

  it "allows a user view a TeeTime that belongs to them" do
    tee_time = TeeTime.create(course_id: course.id, time: Time.now)
    user_tee_time = user.user_tee_times.build(tee_time_id: tee_time.id)
    visit user_tee_time_path(user, tee_time)
    expect(page).to have_content(course.name)
    expect(page).to have_content(user.username)
    expect(page).to have_content(tee_time.time)
  end

end
