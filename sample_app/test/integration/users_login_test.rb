require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:frosty)
    end

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

    test "login with valid information" do
        post login_path, params: {session: { email: @user.email, password: 'password'} }

        # checks correct redirect target
        assert_redirected_to @user

        # visit target page
        follow_redirect!

        assert_template 'users/show'

        #verifies login link disappears (0 links match pattenr)
        assert_select "a[href=?]", login_path, count: 0

        # should see 1 logout link
        assert_select "a[href=?]", logout_path

        # user is logged in; GET request (show) users/[:id]
        assert_select "a[href=?]", user_path(@user)
    end
end