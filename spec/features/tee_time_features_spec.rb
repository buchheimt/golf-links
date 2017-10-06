require_relative "../rails_helper.rb"

describe "TeeTime Features" do
  describe "TeeTime#index", type: :feature do

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

    it "displays with name and time" do
      tee_time1 = course.tee_times.build(time: Time.now)
      tee_time2 = course.tee_times.build(time: Time.now)
      tee_time1.add_user(user)
      tee_time2.add_user(user)
      visit tee_times_path
      expect(page).to have_content(tee_time1.course.name)
      expect(page).to have_content(tee_time1.time.to_s(:long))
      expect(page).to have_content(tee_time2.time.to_s(:long))
    end

    it "defaults to displaying in chronological order" do
      tee_time1 = course.tee_times.build(time: "8:00")
      tee_time2 = course.tee_times.build(time: "4:00")
      tee_time3 = course.tee_times.build(time: "6:00")
      tee_time1.add_user(user)
      tee_time2.add_user(user)
      tee_time3.add_user(user)
      visit tee_times_path
      expect(page.body.index("4:00")).to be < page.body.index("8:00")
    end

    it "has links to tee_time show pages" do
      tee_time = course.tee_times.build(time: Time.now)
      tee_time.add_user(user)
      visit_signin
      user_login
      visit tee_times_path
      click_link tee_time.time.to_s(:long)
      expect(current_path).to eq(tee_time_path(tee_time))
    end

    it "has a link to TeeTime#new" do
      visit tee_times_path
      click_link "Create New Tee Time"
      expect(current_path).to eq(new_tee_time_path)
    end
  end

  describe "TeeTime#new", type: :feature do

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

    # context "when nested in a course" do
    #   it "does not display course fields" do
    #     visit_signin
    #     user_login
    #     visit new_course_tee_time_path(course)
    #     fill_in("tee_time[time]", with: Time.now)
    #     expect(page).to_not have_content("Select Course")
    #     expect(page).to_not have_content("New Course Name")
    #     click_button("Create Tee Time")
    #     expect(current_path).to eq(course_tee_time_path(course, TeeTime.first))
    #     expect(page).to have_content(course.name)
    #     expect(page).to have_content(current_user.username)
    #   end
    # end

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

    # it "redirects back to TeeTime#new if no course is selected or given" do
    #   visit_signin
    #   user_login
    #   visit new_user_tee_time_path(current_user)
    #   fill_in("tee_time[time]", with: Time.now)
    #   click_button("Create Tee Time")
    #   expect(current_path).to eq(new_user_tee_time_path(current_user))
    # end
    #
    # it "redirects back to TeeTime#new if no time is given" do
    #   visit_signin
    #   user_login
    #   visit new_user_tee_time_path(current_user)
    #   fill_in("tee_time[course_attributes][name]", with: "new course")
    #   fill_in("tee_time[course_attributes][description]", with: "description")
    #   fill_in("tee_time[course_attributes][location]", with: "location")
    #   click_button("Create Tee Time")
    #   expect(current_path).to eq(new_user_tee_time_path(current_user))
    # end

  end

  describe "TeeTime#show", type: :feature do

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
end
