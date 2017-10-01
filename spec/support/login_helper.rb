module LoginHelper

  def visit_signin
    visit "/"
    click_link "Sign In" 
  end

  def user_login
    fill_in("user[name]", with: "tylerB")
    fill_in("user[password]", with: "123456")
    click_button("Sign In")
  end

end