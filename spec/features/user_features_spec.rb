require_relative "../rails_helper.rb"

describe "User Features", type: :features do
  describe "Signup", type: :feature do
    context "when logged out" do
      it "successfully creates a new user and redirects to user's show page" do
        visit_signup
        expect(current_path).to eq("/users/new")
        user_signup
        expect(current_path).to eq("/users/1")
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
        expect(current_path).to eq(root_path)
      end
    end
  end

  describe "Login", type: :feature do
    context "when logged out" do
      it "successfully logs in and redirects to user's show page" do
        visit_signin
        expect(current_path).to eq("/signin")
        user_login
        expect(current_path).to eq("/users/1")
        expect(page).to have_content("tylerB")
      end

      it "stores the user id in the sessions hash" do
        visit_signin
        user_login
        expect(page.get_rack_session_key('user_id')).to_not be_nil
      end
    end

    context "when logged in" do
      it "redirects to welcome page" do
        visit_signin
        user_login
        visit signin_path
        expect(current_path).to eq(root_path)
      end
    end
  end

  describe "Logout", type: :feature do
    context "when logged in" do
      it "successfully logs user out and redirects to home page" do
        visit_signin
        user_login
        user_logout
        expect(current_path).to eq(root_path)
      end

      it "clears the user id from the session hash" do
        visit_signin
        user_login
        user_logout
        expect(page.get_rack_session).to_not include(:user_id)
      end
    end
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
        tee_time1 = TeeTime.new(time: Time.now)
        tee_time1.build_course(name: "Augusta National GC")
        tee_time1.save
        user_tee_time1 = UserTeeTime.create(tee_time_id: tee_time1.id, user_id: current_user.id)
        tee_time2 = TeeTime.new(time: Time.now)
        tee_time2.build_course(name: "Pebble Beach Golf Links")
        tee_time2.save
        user_tee_time2 = UserTeeTime.create(tee_time_id: tee_time2.id, user_id: current_user.id)
        visit user_path(current_user)
        expect(page).to have_content("#{tee_time1.course.name} - #{tee_time1.time.to_s(:long)}")
        expect(page).to have_content("#{tee_time2.course.name} - #{tee_time2.time.to_s(:long)}")
      end

      it "displays associated tee times as links to nested tee time show page" do
        visit_signin
        user_login
        tee_time = course.tee_times.build(time: Time.now)
        tee_time.add_user(current_user)
        visit user_path(current_user)
        click_link(tee_time.time.to_s(:long))
        expect(current_path).to eq(user_tee_time_path(current_user, tee_time))
      end
    end

    context "when different user" do
      it "doesn't display all of user's tee times" do
        visit_signin
        user_login
        tee_time1 = TeeTime.new(time: Time.now)
        tee_time1.build_course(name: "Augusta National GC")
        tee_time1.save
        user_tee_time1 = UserTeeTime.create(tee_time_id: tee_time1.id, user_id: user.id)
        tee_time2 = TeeTime.new(time: Time.now)
        tee_time2.build_course(name: "Pebble Beach Golf Links")
        tee_time2.save
        user_tee_time2 = UserTeeTime.create(tee_time_id: tee_time2.id, user_id: user.id)
        visit user_path(user)
        expect(page).to_not have_content("#{tee_time1.course.name} - #{tee_time1.time}")
        expect(page).to_not have_content("#{tee_time2.course.name} - #{tee_time2.time}")
      end

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
        expect(page).to_not have_content("Edit Profile")
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
      it "allows user to properly edit info" do
        visit_signin
        user_login
        visit edit_user_path(current_user)
        select(1, from: "user[pace]")
        fill_in("user[password]", with: "123456")
        fill_in("user[password_confirmation]", with: "123456")
        click_button("Update User")
        expect(current_user.pace).to eq(1)
      end

      it "redirects to User#show upon successful edit" do
        visit_signin
        user_login
        visit edit_user_path(current_user)
        select(1, from: "user[pace]")
        fill_in("user[password]", with: "123456")
        fill_in("user[password_confirmation]", with: "123456")
        click_button("Update User")
        expect(current_path).to eq(user_path(current_user))
      end
    end

    context "when different user" do
      it "redirects to welcome page" do
        user = User.create(user_attributes)
        visit_signin
        user_login
        visit edit_user_path(user)
        expect(current_path).to eq(root_path)
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
end
