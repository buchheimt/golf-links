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
