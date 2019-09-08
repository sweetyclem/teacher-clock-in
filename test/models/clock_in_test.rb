require 'test_helper'

class ClockInTest < ActiveSupport::TestCase

  test "should not save clock_in without teacher" do
    clock_in = ClockIn.new
    assert_not clock_in.valid?
    clock_in.errors.added? :teacher
    assert_not clock_in.save
  end
  
  test "should save clock_in" do
    clock_in = ClockIn.new
    clock_in.teacher = teachers(:teacherOne)
    clock_in.start = DateTime.current
    assert clock_in.valid?
    assert clock_in.save
  end
end
