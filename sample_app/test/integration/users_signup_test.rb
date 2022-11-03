require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    # technically unnecessary but adds conceptual clarity and to double-check
    get signup_path
    # check User.count before and after signup to make sure an invalid user was not created
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar"
        }
      }
    end
    # verify correct status returned
    assert_response :unprocessable_entity
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count' do
      post users_path, params: {
        user: {
          name: "Alice",
          email: "alice@example.com",
          password: "123456",
          password_confirmation: "123456"
        }
      }
    end
    follow_redirect!
    assert_template 'static_pages/home'
    # # call test_helper method
    # assert is_logged_in?
  end
end
