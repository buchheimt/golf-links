module LoginHelper

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

end
