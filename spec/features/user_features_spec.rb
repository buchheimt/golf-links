require_relative "../rails_helper.rb"

describe "Feature Test: User Signup", type: :feature do
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

describe "Feature Test: User Login", type: :feature do
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

describe "Feature Test: User Logout", type: :feature do
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

describe "Feature Test: User#show", type: :feature do

  before :each do
    User.create(
      username: "tylerB",
      email: "tyler@gmail.com",
      password: "123456",
      password_confirmation: "123456"
    )
  end

  let(:user) {
    User.first
  }

  it "displays all of user's tee times" do
    tee_time1 = TeeTime.new(time: Time.now)
    tee_time1.build_course(name: "Augusta National GC")
    tee_time1.save
    user_tee_time1 = UserTeeTime.create(tee_time_id: tee_time1.id, user_id: user.id)
    tee_time2 = TeeTime.new(time: Time.now)
    tee_time2.build_course(name: "Pebble Beach Golf Links")
    tee_time2.save
    user_tee_time2 = UserTeeTime.create(tee_time_id: tee_time2.id, user_id: user.id)
    visit user_path(user)
    expect(page).to have_content("#{tee_time1.course.name} - #{tee_time1.time}")
    expect(page).to have_content("#{tee_time2.course.name} - #{tee_time2.time}")
  end

  it "links to User/TeeTime#new" do
    visit user_path(user)
    click_link("Create New Tee Time")
    expect(current_path).to eq(new_user_tee_time_path(user))
  end
end
