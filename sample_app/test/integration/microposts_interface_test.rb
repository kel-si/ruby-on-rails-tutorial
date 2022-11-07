require "test_helper"

class MicropostsInterface < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:frosty)
    log_in_as(@user)
  end
end

class MicropostsInterfaceTest < MicropostsInterface

  test "should paginate microposts" do
  end

  test "should not create micropost on invalid submission and show errors" do
  end

  test "should create a micropost on valid submission" do
  end

  test "should have micropost delete links on own profile page" do
  end

  test "should be able to delete own micropost" do
  end

  test "should not have delete links on other user's profile page" do
  end
end
