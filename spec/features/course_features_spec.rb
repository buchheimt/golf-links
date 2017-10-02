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

  let(:course) {
    Course.create(
      name: "Augusta National GC",
      description: "Home of the Masters",
      location: "Augusta, GA"
    )
  }

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

end
