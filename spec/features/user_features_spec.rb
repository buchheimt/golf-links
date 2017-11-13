require_relative "../rails_helper.rb"

describe "User Features", type: :features do
  describe "Signup", type: :feature do
    context "when logged out" do
      it "successfully creates a new user and redirects to user's show page" do
        visit_signup
        expect(current_path).to eq("/users/new")
        user_signup
        expect(current_path).to eq(user_path(User.last))
        expect(page).to have_content("tylerB")
      end

      it "stores the user id in the sessions hash" do
        visit_signup
        user_signup
        expect(page.get_rack_session_key('user_id')).to_not be_nil
      end
    end

    context "when logged in" do
      it "redirects to welcome page" do
        visit_signin
        user_login
        visit new_user_path
        expect(current_path).to eq(user_path(current_user))
      end
    end
  end

  describe "Login", type: :feature do
    context "when logged out" do
      it "successfully logs in and redirects to user's show page" do
        visit_signin
        expect(current_path).to eq("/signin")
        user_login
        expect(current_path).to eq(user_path(User.last))
        expect(page).to have_content("tylerB")
      end

      it "stores the user id in the sessions hash" do
        visit_signin
        user_login
        expect(page.get_rack_session_key('user_id')).to_not be_nil
      end
    end
  end

  describe "Logout", type: :feature do
    # context "when logged in" do
    #   it "successfully logs user out and redirects to home page" do
    #     visit_signin
    #     user_login
    #     user_logout
    #     expect(current_path).to eq(root_path)
    #   end
    #
    #   it "clears the user id from the session hash" do
    #     visit_signin
    #     user_login
    #     user_logout
    #     expect(page.get_rack_session).to_not include(:user_id)
    #   end
    # end
  end

  describe "User#show", type: :feature do

    before :each do
      User.create(
        username: "johnS",
        email: "john@gmail.com",
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

    context "when admin on non-admin profile" do
      it "has a link to make user an admin" do
        visit_signin
        admin_login
        visit user_path(user)
        click_button "Make Admin"
        user = User.first
        expect(user.admin?).to be true
      end
    end

    context "when not admin or on an admin profile" do
      it "doesn't have link to make already admin an admin" do
        visit_signin
        admin_login
        user.role = "admin"
        user.save
        visit user_path(user)
        expect(page).to_not have_content("Make Admin")
      end

      it "doesn't have link if current user isn't an admin" do
        visit_signin
        user_login
        visit user_path(user)
        expect(page).to_not have_content("Make Admin")
      end
    end

    context "when correct user" do
      it "links to User/TeeTime#new" do
        visit_signin
        user_login
        visit user_path(current_user)
        click_link("Create New Tee Time")
        expect(current_path).to eq(new_user_tee_time_path(current_user))
      end

      it "links to User#edit" do
        visit_signin
        user_login
        visit user_path(current_user)
        click_link("Edit Profile")
        expect(current_path).to eq(edit_user_path(current_user))
      end

      it "displays all of user's tee times" do
        visit_signin
        user_login
        course1 = Course.create(name: "Augusta National GC", location: "test")
        tee_time1 = course1.tee_times.build(time: "Dec 1 2098")
        tee_time1.user_tee_times.build(user_id: current_user.id)
        course2 = Course.create(name: "Pebble Beach Golf Links", location: "test2")
        tee_time2 = course2.tee_times.build(time: "Dec 1 2099")
        tee_time2.user_tee_times.build(user_id: current_user.id)
        course1.save
        course2.save
        visit user_path(current_user)
        expect(page).to have_content(tee_time1.course.name)
        expect(page).to have_content(tee_time1.time.year)
        expect(page).to have_content(tee_time2.course.name)
        expect(page).to have_content(tee_time2.time.year)
      end

      it "displays associated tee times as links to nested tee time show page" do
        visit_signin
        user_login
        tee_time = course.tee_times.build(time: "Dec 1 2099")
        tee_time.add_user(current_user)
        visit user_path(current_user)
        click_link(tee_time.time.year)
        expect(current_path).to eq(user_tee_time_path(current_user, tee_time))
      end

      it "defaults to displaying associated tee times in chronological order" do
        visit_signin
        user_login
        tee_time1 = course.tee_times.build(time: "Dec 1 2099")
        tee_time2 = course.tee_times.build(time: "Dec 1 2097")
        tee_time3 = course.tee_times.build(time: "Dec 1 2098")
        tee_time1.user_tee_times.build(user_id: current_user.id)
        tee_time2.user_tee_times.build(user_id: current_user.id)
        tee_time3.user_tee_times.build(user_id: current_user.id)
        course.save
        visit user_path(current_user)
        expect(page.body.index(tee_time2.time.year.to_s)).to be < page.body.index(tee_time1.time.year.to_s)
      end

      it "does not display tee times that have already taken place" do
        visit_signin
        user_login
        tee_time1 = course.tee_times.build(time: Time.now)
        tee_time1.add_user(current_user)
        visit user_path(current_user)
        expect(page).to_not have_content("Group Size:")
      end
    end

    context "when different user" do
      it "doesn't link to User/TeeTime#new" do
        visit_signin
        user_login
        visit user_path(user)
        expect(page).to_not have_content("Create New Tee Time")
      end

      it "doesn't link to User#edit" do
        visit_signin
        user_login
        visit user_path(user)
        expect(page).to_not have_content(edit_user_path(user))
      end
    end

    context "when logged out" do
      it "redirects to welcome page" do
        visit user_path(user)
        expect(current_path).to eq(root_path)
      end
    end
  end

  describe "User#edit", type: :feature do

    let(:user_attributes) do {
        username: "jonS",
        email: "jon@gmail.com",
        password: "123456",
        password_confirmation: "123456",
        pace: 8,
        experience: 7
      }
    end

    context "when correct user" do
      it "redirects to User#show upon successful edit" do
        visit_signin
        user_login
        visit edit_user_path(current_user)
        fill_in("user[password]", with: "123456")
        fill_in("user[password_confirmation]", with: "123456")
        click_button("Update User")
        expect(current_path).to eq(user_path(current_user))
      end

      it "has link to delete user" do
        visit_signin
        user_login
        visit edit_user_path(current_user)
        expect(page).to have_content("Delete User")
      end
    end

    context "when different user" do
      it "redirects to welcome page" do
        user = User.create(user_attributes)
        visit_signin
        user_login
        visit edit_user_path(user)
        expect(current_path).to eq(user_path(current_user))
      end
    end

    context "when logged out" do
      it "redirects to welcome page" do
        user = User.create(user_attributes)
        visit edit_user_path(user)
        expect(current_path).to eq(root_path)
      end
    end
  end

  describe "User#edit", type: :feature do

    before :each do
      User.create(
        username: "johnS",
        email: "john@gmail.com",
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

    # it "destroys User" do
    #   user_id = user.id
    #   visit_signin
    #   admin_login
    #   visit edit_user_path(user)
    #   click_link "Delete User"
    #   expect(current_path).to eq(root_path)
    #   expect(User.find_by_id(user_id)).to be_nil
    # end
    #
    # it "destroys user tee times" do
    #   tee_time = course.tee_times.build(time: "Dec 1 2098")
    #   tee_time.add_user(user)
    #   user_tee_time_id = tee_time.user_tee_times.first.id
    #   visit_signin
    #   admin_login
    #   visit edit_user_path(user)
    #   click_link "Delete User"
    #   expect(current_path).to eq(root_path)
    #   expect(UserTeeTime.find_by_id(user_tee_time_id)).to be_nil
    # end
  end
end
