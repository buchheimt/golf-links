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

  it "allows a user to create a new TeeTime with an existing course" do
    visit_signin
    user_login
    visit new_user_tee_time_path(user)
    fill_in("tee_time[time]", with: Time.now)
    select(course.name, from: "tee_time[course_id]")
    click_button("Create Tee Time")
    expect(current_path).to eq(user_tee_time_path(user, TeeTime.first))
    expect(page).to have_content(course.name)
  end

  it "allows a user to create a new TeeTime with an existing course" do
    visit_signin
    user_login
    visit new_user_tee_time_path(user)
    fill_in("tee_time[time]", with: Time.now)
    fill_in("tee_time[course_attributes][name]", with: "new course")
    fill_in("tee_time[course_attributes][description]", with: "description")
    fill_in("tee_time[course_attributes][location]", with: "location")
    click_button("Create Tee Time")
    expect(current_path).to eq(user_tee_time_path(user, TeeTime.first))
    expect(page).to have_content("new course")
  end

  it "redirects back to TeeTime#new if no course is selected or given" do
    visit_signin
    user_login
    visit new_user_tee_time_path(current_user)
    fill_in("tee_time[time]", with: Time.now)
    click_button("Create Tee Time")
    expect(current_path).to eq(new_user_tee_time_path(current_user))
  end

  it "redirects back to TeeTime#new if no time is given" do
    visit_signin
    user_login
    visit new_user_tee_time_path(current_user)
    fill_in("tee_time[course_attributes][name]", with: "new course")
    fill_in("tee_time[course_attributes][description]", with: "description")
    fill_in("tee_time[course_attributes][location]", with: "location")
    click_button("Create Tee Time")
    expect(current_path).to eq(new_user_tee_time_path(current_user))
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
    visit_signin
    user_login
    tee_time = TeeTime.create(course_id: course.id, time: Time.now)
    user_tee_time = user.user_tee_times.build(tee_time_id: tee_time.id)
    visit user_tee_time_path(user, tee_time)
    expect(page).to have_content(course.name)
    expect(page).to have_content(user.username)
    expect(page).to have_content(tee_time.time.to_s(:long))
  end

end
