module LoginHelper

  def visit_signup
    visit "/"
    click_link "Sign Up"
  end

  def user_signup
    fill_in("user[username]", with: "tylerB")
    fill_in("user[email]", with: "tyler@gmail.com")
    fill_in("user[password]", with: "123456")
    fill_in("user[password_confirmation]", with: "123456")
    click_button("Sign Up")
  end

  def visit_signin
    visit "/"
    click_link "Sign In"
  end

  def user_login
    User.create(
      username: "tylerB",
      email: "tyler@gmail.com",
      password: "123456",
      password_confirmation: "123456"
    )
    fill_in("user[username]", with: "tylerB")
    fill_in("user[password]", with: "123456")
    click_button("Sign In")
  end

  def user_logout
    visit "/"
    click_link "Sign Out"
  end

  def current_user
    User.find_by_id(session[:user_id])
  end

end
