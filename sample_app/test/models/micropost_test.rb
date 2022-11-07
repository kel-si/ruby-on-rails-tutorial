require "test_helper"

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:frosty)
    # idiomatically correct - new micropost through the user it belongs to
    # build returns an object in memory but does not modify the db
    @micropost = @user.microposts.build(content: "lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present in micropost" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "micropost content should be <= 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
end
