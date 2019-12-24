require 'test_helper'

class TeachersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get root_path
    assert_no_difference 'Teacher.count' do
      post teachers_path, school: {name: "invalid",
                                   city: "Berkeley",
                                   state: "CA",
                                   website: "invalid.com"
                                  }, teacher: {
                                      first_name: "",
                                      last_name: "invalid",
                                      email: "invalid@invalid.edu",
                                      course: "invalid",
                                      snap: "invalid"
                                  }
    end
    assert_equal "Failed to submit information :(", flash[:alert]
  end


  test "valid signup information" do
    get root_path
    assert_difference 'Teacher.count', 1 do
      post teachers_path, school: {name: "valid_example",
                                city: "Berkeley",
                                state: "CA",
                                website: "valid_example.com"
                                }, teacher: {
                                first_name: "valid_example",
                                last_name: "valid_example",
                                email: "valid_example@valid_example.edu",
                                course: "valid_example",
                                snap: "valid_example"
                                }
    end
    assert_equal true, flash[:saved_teacher]
  end

end
