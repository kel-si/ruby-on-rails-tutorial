require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:frosty)
  end

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path

    get signup_path
    assert_template 'users/new'
    assert_equal "Sign Up | Ruby on Rails Tutorial Sample App", full_title("Sign Up")
    log_in_as(@user)
    assert users_path
    delete logout_path
    assert_select "a[href=?]", users_path, count: 0
  end
end
