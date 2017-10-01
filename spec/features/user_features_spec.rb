require_relative "../rails_helper.rb"

describe "Feature Test: User Login", type: :feature do
  it "successfully logs in" do
    visit_signin
    expect(current_path).to eq("/signin")
    user_login
    expect(current_path).to eq("/users/1")
    expect(page).to have_content("tylerB")
  end
end