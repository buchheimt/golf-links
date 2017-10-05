require_relative "../rails_helper.rb"

describe "Feature Test: Courses Index", type: :feature do

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

  it "with name and location" do
    visit courses_path
    expect(page).to have_content(course.name)
    expect(page).to have_content(course.location)
  end

  it "as links to course show pages" do
    visit courses_path
    click_link "Augusta National GC"
    expect(current_path).to eq(course_path(course))
  end

end

describe "Feature Test: Course Show", type: :feature do

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

  context "when logged in" do
    it "links to Course/TeeTime#new" do
      visit_signin
      user_login
      visit course_path(course)
      click_link("Create New Tee Time")
      expect(current_path).to eq(new_course_tee_time_path(course))
    end
  end

  context "when logged out" do
    it "doesn't link to User/TeeTime#new" do
      visit course_path(course)
      expect(page).to_not have_content("Create New Tee Time")
    end
  end

  it "displays a course name" do
    visit course_path(course)
    expect(page).to have_content("Augusta National GC")
  end

  it "displays a course description" do
    visit course_path(course)
    expect(page).to have_content("Home of the Masters")
  end

  it "displays a course location" do
    visit course_path(course)
    expect(page).to have_content("Augusta, GA")
  end

  it "displays tee times scheduled for the course" do
    tee_time = course.tee_times.build(time: Time.now)
    tee_time.add_user(user)
    visit course_path(course)
    expect(page).to have_content(tee_time.time.to_s(:long))
  end

  it "displays associated tee times as links to nested tee time show page" do
    tee_time = course.tee_times.build(time: Time.now)
    tee_time.add_user(user)
    visit course_path(course)
    click_link(tee_time.time.to_s(:long))
    expect(current_path).to eq(course_tee_time_path(course, tee_time))
  end

end
