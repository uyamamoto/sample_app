require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: { user: { name: "", email: "foo@invalid", password: "foo", password_confirmation: "bar" } }
    assert_template "users/edit"
    assert_select "div.alert", "The form contains 4 errors."
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name, email: email, password: "", password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  # 演習10.2
  test "friendly forwarding only forwards to the given URL the first time" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    delete logout_path
    assert_redirected_to root_url
    log_in_as(@user)
    assert_redirected_to @user
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
end
