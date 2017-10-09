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
    click_button("Create User")
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
      password_confirmation: "123456",
      pace: 8,
      experience: 7
    )
    fill_in("user[username]", with: "tylerB")
    fill_in("user[password]", with: "123456")
    click_button("Sign In")
  end

  def admin_login
    User.create(
      username: "tyler10000",
      email: "ty@gmail.com",
      password: "123456",
      password_confirmation: "123456",
      pace: 8,
      experience: 7,
      role: 1
    )
    fill_in("user[username]", with: "tyler10000")
    fill_in("user[password]", with: "123456")
    click_button("Sign In")
  end

  def user_logout
    visit "/"
    click_link "Sign Out"
  end

  def current_user
    @current_user = User.find_by_id(page.get_rack_session_key('user_id')) if page.get_rack_session_key('user_id')
  end

  def format_tee_time(tee_time)
    tee_time.time.strftime("%A %B %e, %Y | %l:%m %p")
  end

end
