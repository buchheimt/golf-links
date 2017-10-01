require_relative "../rails_helper.rb"

describe "Feature Test: User Login", type: :feature do
  it "successfully logs in" do
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
