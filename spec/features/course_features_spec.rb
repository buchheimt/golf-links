require_relative "../rails_helper.rb"

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
