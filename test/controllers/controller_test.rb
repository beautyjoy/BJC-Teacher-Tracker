require 'test_helper'

class ControllerTest < ActionDispatch::IntegrationTest

  test "should get to root" do
    get root_url
    assert_response :success
    assert_select "title", "BjcTeacherTracker"
  end
end
