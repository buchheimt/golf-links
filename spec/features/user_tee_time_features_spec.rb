require_relative "../rails_helper.rb"

describe "UserTeeTime Features", type: :feature do
  describe "UserTeeTime#create", type: :feature do

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

    before :each do
      User.create(
        username: "tylerB",
        email: "tyler@gmail.com",
        password: "123456",
        password_confirmation: "123456",
        pace: 8,
        experience: 7
      )
    end

    let(:course) {
      Course.first
    }

    let(:user) {
      User.first
    }

    context "when logged in" do
      it "adds the current user to the tee time" do
        visit_signin
        user_login
        tee_time = course.tee_times.build(course_id: course.id, time: "Dec 1 2099")
        tee_time.user_tee_times.build(user_id: User.create(user_attributes).id)
        course.save
        visit tee_time_path(tee_time)
        click_button("Join Tee Time")
        expect(tee_time.users).to include(current_user)
      end

      it "is unavailable if user has already joined" do
        visit_signin
        user_login
        tee_time = course.tee_times.build(course_id: course.id, time: "Dec 1 2099")
        tee_time.user_tee_times.build(user_id: user.id)
        course.save
        visit tee_time_path(tee_time)
        expect(page).to_not have_content("Join Tee Time")
      end
    end
  end

  describe "UserTeeTime#edit", type: :feature do

    before :each do
      Course.create(
        name: "Augusta National GC",
        description: "Home of the Masters",
        location: "Augusta, GA"
      )
    end

    before :each do
      User.create(
        username: "tylerB",
        email: "tyler@gmail.com",
        password: "123456",
        password_confirmation: "123456",
        pace: 8,
        experience: 7
      )
    end

    let(:course) {
      Course.first
    }

    let(:user) {
      User.first
    }

    context "add a guest" do
      it "adds a guest to tee time" do
        visit_signin
        user_login
        tee_time = course.tee_times.build(time: "Dec 1 2099")
        tee_time.user_tee_times.build(user_id: user.id)
        course.save
        visit tee_time_path(tee_time)
        click_button("Add a Guest")
        expect(TeeTime.last.group_size).to eq(2)
      end
    end

    context "remove a guest" do
      it "removes a guest from tee time" do
        visit_signin
        user_login
        tee_time = course.tee_times.build(time: "Dec 1 2099")
        tee_time.user_tee_times.build(user_id: user.id)
        course.save
        visit tee_time_path(tee_time)
        click_button("Add a Guest")
        visit tee_time_path(tee_time)
        expect(TeeTime.last.group_size).to eq(2)
        click_button("Remove a Guest")
        expect(TeeTime.last.group_size).to eq(1)
      end
    end

  end
end
