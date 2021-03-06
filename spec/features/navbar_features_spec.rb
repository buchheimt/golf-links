require_relative "../rails_helper.rb"

describe "Feature Test: Navbar", type: :feature do

  it "has a link to the root page" do
    visit courses_path
    click_link "Golf Links"
    expect(current_path).to eq(root_path)
  end

  it "has a link to Courses index" do
    visit root_path
    click_link "Courses"
    expect(current_path).to eq(courses_path)
  end

  # it "has a link to User's profile page" do
  #   visit_signin
  #   user_login
  #   current_user
  #   visit root_path
  #   expect(page).to have_content(@current_user.username)
  #   click_link(@current_user.username)
  #   expect(current_path).to eq(user_path(@current_user))
  # end

end
