require 'test_helper'

class TeacherTest < ActiveSupport::TestCase

  def setup
    @teacher = teachers(:ye)
  end

  test "should be valid" do
    assert @teacher.valid?
  end
end
