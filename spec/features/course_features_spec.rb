require_relative "../rails_helper.rb"

describe "Course Features", type: :feature do
  describe "Course#index", type: :feature do

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

    it "displays with name and location" do
      visit courses_path
      expect(page).to have_content(course.name)
      expect(page).to have_content(course.location)
    end

    it "has links to course show pages" do
      visit courses_path
      click_link "Augusta National GC"
      expect(current_path).to eq(course_path(course))
    end

    it "has a link to Course#new" do
      visit_signin
      user_login
      visit courses_path
      click_link "Add New Course"
      expect(current_path).to eq(new_course_path)
    end

  end

  describe "Course#show", type: :feature do

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

    context "as admin" do
      it "has a link to Course#edit" do
        visit_signin
        admin_login
        visit course_path(course)
        expect(page).to have_content("Edit Course")
        click_link "Edit Course"
        expect(current_path).to eq(edit_course(course))
      end
    end

    context "when logged in" do
      it "links to Course/TeeTime#new" do
        visit_signin
        user_login
        visit course_path(course)
        click_link("Create New Tee Time")
        expect(current_path).to eq(new_course_tee_time_path(course))
      end

      it "does not link to Course#edit if not an admin" do
        visit_signin
        user_login
        visit course_path(course)
        expect(page).to_not have_content("Edit Course")
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
      tee_time = course.tee_times.build(time: "Dec 1 2099")
      tee_time.add_user(user)
      visit course_path(course)
      expect(page).to have_content(format_tee_time(tee_time))
    end

    it "displays associated tee times as links to nested tee time show page" do
      tee_time = course.tee_times.build(time: "Dec 1 2099")
      tee_time.add_user(user)
      visit course_path(course)
      click_link(tee_time.time.year)
      expect(current_path).to eq(course_tee_time_path(course, tee_time))
    end

    it "defaults to displaying associated tee times in chronological order" do
      tee_time1 = course.tee_times.build(time: "Dec 1 2099")
      tee_time2 = course.tee_times.build(time: "Dec 1 2097")
      tee_time3 = course.tee_times.build(time: "Dec 1 2098")
      tee_time1.add_user(user)
      tee_time2.add_user(user)
      tee_time3.add_user(user)
      visit course_path(course)
      expect(page.body.index(tee_time2.time.year.to_s)).to be < page.body.index(tee_time1.time.year.to_s)
    end

    it "does not display tee times that have already taken place" do
      tee_time1 = course.tee_times.build(time: Time.now)
      tee_time1.add_user(user)
      visit course_path(course)
      expect(page).to_not have_content(tee_time1.time.year)
    end

  end
end
