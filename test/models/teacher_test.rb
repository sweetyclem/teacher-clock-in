require 'test_helper'

class TeacherTest < ActiveSupport::TestCase

  test "should not save teacher without name" do
    teacher = Teacher.new
    teacher.email = 'test1@clesm.dev'
    teacher.password = 'password1'
    assert_not teacher.valid?
    teacher.errors.added? :name
    assert_not teacher.save
  end
  
  test "should not save teacher without email" do
    teacher = Teacher.new
    teacher.name = 'Teacher test'
    teacher.password = 'password1'
    assert_not teacher.valid?
    teacher.errors.added? :email
    assert_not teacher.save
  end

  test "should save teacher" do
    teacher = teachers(:teacherOne)
    assert teacher.valid?
    assert teacher.save
  end
end
