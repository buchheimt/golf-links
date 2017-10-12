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
end
