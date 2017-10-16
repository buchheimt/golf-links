require_relative "../rails_helper.rb"

describe "TeeTime Features" do
  describe "TeeTime#index", type: :feature do

    before :each do
      User.create(
        username: "tylerB",
        email: "tyler@gmail.com",
        password: "123456",
        password_confirmation: "123456",
        pace: 4,
        experience: 6
      )
    end

    before :each do
      User.create(
        username: "jonS",
        email: "jon@gmail.com",
        password: "123456",
        password_confirmation: "123456",
        pace: 2,
        experience: 8
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

    let(:user2) {
      User.last
    }

    let(:course) {
      Course.first
    }

    it "displays with name and time" do
      tee_time1 = course.tee_times.build(time: "Dec 1 2098")
      tee_time2 = course.tee_times.build(time: "Dec 1 2099")
      tee_time1.user_tee_times.build(user_id: user.id)
      tee_time2.user_tee_times.build(user_id: user.id)
      course.save
      visit tee_times_path
      expect(page).to have_content(tee_time1.course.name)
      expect(page).to have_content("Dec 1, 2098")
      expect(page).to have_content("Dec 1, 2099")
    end

    it "displays with size, avg pace, and avg experience" do
      tee_time = course.tee_times.build(time: "Dec 1 2099")
      tee_time.add_user(user)
      tee_time.add_user(user2)
      visit tee_times_path
      expect(page).to have_content("Avg. Pace: 3.0")
      expect(page).to have_content("Avg. Experience: 7.0")
      expect(page).to have_content("Size: 2/4")
    end

    it "defaults to displaying in chronological order" do
      tee_time1 = course.tee_times.build(time: "Dec 1 2099")
      tee_time2 = course.tee_times.build(time: "Dec 1 2097")
      tee_time3 = course.tee_times.build(time: "Dec 1 2098")
      tee_time1.user_tee_times.build(user_id: user.id)
      tee_time2.user_tee_times.build(user_id: user.id)
      tee_time3.user_tee_times.build(user_id: user.id)
      course.save
      visit tee_times_path
      expect(page.body.index(tee_time2.time.year.to_s)).to be < page.body.index(tee_time1.time.year.to_s)
    end

    it "does not display tee times that have already taken place" do
      tee_time1 = course.tee_times.build(time: Time.now)
      tee_time1.add_user(user)
      visit tee_times_path
      expect(page).to_not have_content(format_tee_time(tee_time1))
    end

    it "has links to tee_time show pages" do
      tee_time = course.tee_times.build(time: "Dec 1 2099")
      tee_time.add_user(user)
      visit_signin
      user_login
      visit tee_times_path
      click_link tee_time.time.year
      expect(current_path).to eq(tee_time_path(tee_time))
    end

    it "has a link to TeeTime#new" do
      visit_signin
      user_login
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

    it "allows a user to create a new TeeTime with an existing course" do
      visit_signin
      user_login
      visit new_user_tee_time_path(user)
      select("2018", from: "tee_time[time(1i)]")
      select(course.name, from: "tee_time[course_id]")
      click_button("Create Tee Time")
      expect(current_path).to eq(user_tee_time_path(user, TeeTime.first))
      expect(page).to have_content(course.name)
    end

    it "allows a user to create a new TeeTime with a new course" do
      visit_signin
      user_login
      visit new_user_tee_time_path(user)
      select("2018", from: "tee_time[time(1i)]")
      fill_in("tee_time[course_attributes][name]", with: "new course")
      fill_in("tee_time[course_attributes][description]", with: "description")
      fill_in("tee_time[course_attributes][location]", with: "location")
      click_button("Create Tee Time")
      expect(current_path).to eq(user_tee_time_path(user, TeeTime.first))
      expect(page).to have_content("new course")
    end

    it "handles selecting a guest count" do
      visit_signin
      user_login
      visit new_user_tee_time_path(user)
      select("2018", from: "tee_time[time(1i)]")
      select(course.name, from: "tee_time[course_id]")
      select('2', from: "tee_time[user_tee_times_attributes][0][guest_count]")
      click_button("Create Tee Time")
      expect(current_path).to eq(user_tee_time_path(user, TeeTime.first))
      expect(page).to have_content(course.name)
      expect(TeeTime.first.group_size).to eq(3)
    end
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

    let(:user_attributes) do {
        username: "jonS",
        email: "jon@gmail.com",
        password: "123456",
        password_confirmation: "123456",
        pace: 8,
        experience: 7
      }
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

    let(:user_attributes2) {user_attributes.merge(username: "user2", email: "u2@g.c")}
    let(:user_attributes3) {user_attributes.merge(username: "user3", email: "u3@g.c")}
    let(:user_attributes4) {user_attributes.merge(username: "user4", email: "u4@g.c")}

    it "allows a user view a TeeTime" do
      visit_signin
      user_login
      tee_time = course.tee_times.build(time: "Dec 1 2099")
      user_tee_time = tee_time.user_tee_times.build(user_id: user.id)
      course.save
      visit user_tee_time_path(user, tee_time)
      expect(page).to have_content(course.name)
      expect(page).to have_content(user.username)
      expect(page).to have_content(tee_time.time.year)
    end

    it "doesn't display a Join Tee Time button if full" do
      tee_time = course.tee_times.build(time: "Dec 1 2099")
      tee_time.add_user(User.create(user_attributes))
      tee_time.add_user(User.create(user_attributes2))
      tee_time.add_user(User.create(user_attributes3))
      tee_time.add_user(User.create(user_attributes4))
      visit_signin
      user_login
      visit tee_time_path(tee_time)
      expect(page).to_not have_content("Join Tee Time")
    end

    it "doesn't display a Join Tee Time button if already joined" do
      tee_time = course.tee_times.build(time: "Dec 1 2099")
      visit_signin
      user_login
      tee_time.add_user(current_user)
      visit tee_time_path(tee_time)
      expect(page).to_not have_content("Join Tee Time")
    end

  end
end
