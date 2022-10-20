require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
    test "full helper title" do
        assert_equal "Ruby on Rails Tutorial Sample App", full_title
        assert_equal "Help | Ruby on Rails Tutorial Sample App", full_title("Help")
    end
end