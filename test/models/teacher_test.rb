require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @school = schools(:stanford)
    @teacher = @school.teachers.build(:ye)
  end

  test "should be valid" do
    assert @teacher.valid?
  end
end
