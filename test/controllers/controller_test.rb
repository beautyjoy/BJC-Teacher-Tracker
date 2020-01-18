require 'test_helper'

class ControllerTest < ActionDispatch::IntegrationTest

  test "should get to root" do
    get root_url
    assert_response :redirect, to: teachers_path
  end
end
