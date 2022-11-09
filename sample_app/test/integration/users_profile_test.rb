require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:frosty)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    # # checks for img tag inside an h1 tag
    assert_select 'h1>img.gravatar'
    # number of microposts appears somewhere on the page
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
    assert_select 'div.pagination', count: 1
  end

  test "correct following stats appear on home page" do
    log_in_as(@user)
    get root_url
    assert_match @user.following.count.to_s, response.body
  end

  test "correct followed stats appear on home page" do
    log_in_as(@user)
    get root_url
    assert_match @user.followers.count.to_s, response.body
  end
end
