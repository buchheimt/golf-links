require_relative "../rails_helper.rb"

describe "UserTeeTime Features", type: :feature do
  describe "UserTeeTime#create", type: :feature do

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

    context "when logged in" do
      it "adds the current user to the tee time" do
        visit_signin
        user_login
        tee_time = TeeTime.create(course_id: course.id, time: "Dec 1 2099")
        visit tee_time_path(tee_time)
        click_button("Join Tee Time")
        expect(tee_time.users).to include(current_user)
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

    let(:course) {
      Course.first
    }

    context "add a guest" do
      it "adds a guest to tee time" do
        visit_signin
        user_login
        tee_time = TeeTime.create(course_id: course.id, time: "Dec 1 2099")
        visit tee_time_path(tee_time)
        click_button("Join Tee Time")
        visit tee_time_path(tee_time)
        click_button("Add a Guest")
        expect(tee_time.group_size).to eq(2)
      end
    end

    context "remove a guest" do
      it "removes a guest from tee time" do
        visit_signin
        user_login
        tee_time = TeeTime.create(course_id: course.id, time: "Dec 1 2099")
        visit tee_time_path(tee_time)
        click_button("Join Tee Time")
        visit tee_time_path(tee_time)
        click_button("Add a Guest")
        visit tee_time_path(tee_time)
        click_button("Remove a Guest")
        expect(tee_time.group_size).to eq(1)
      end
    end

  end
end
