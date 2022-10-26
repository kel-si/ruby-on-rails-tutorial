require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
    test "user login with invalid information" do
        get login_path
        assert_template "new" # same result as "sessions/new"
        post login_path, params: { session: { email: "foo@", password: "wrong" } }
   
        assert_response :unprocessable_entity
        assert_template "new"
        assert_not flash.empty?
        get root_path
        assert flash.empty?
    end
end