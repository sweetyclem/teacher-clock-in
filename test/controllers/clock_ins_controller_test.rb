require 'test_helper'

class ClockInsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test 'should be redirected from index when not logged in' do
    get :index

    assert_response :redirect
    assert_redirected_to new_teacher_session_path
  end
  
  test 'should be redirected from edit when not logged in' do
    get :edit, params: { id: clock_ins(:one).id }

    assert_response :redirect
    assert_redirected_to new_teacher_session_path
  end
  
  test 'should be redirected from create when not logged in' do
    post :create

    assert_response :redirect
    assert_redirected_to new_teacher_session_path
  end
  
  test 'should be redirected from update when not logged in' do
    patch :update, params: { id: clock_ins(:one).id }

    assert_response :redirect
    assert_redirected_to new_teacher_session_path
  end
  
  test 'should be redirected from destroy when not logged in' do
    delete :destroy, params: { id: clock_ins(:one).id }

    assert_response :redirect
    assert_redirected_to new_teacher_session_path
  end
  
  test 'should get index' do
    sign_in teachers(:teacherOne)
    get :index

    assert_response :success
  end
  
  test 'should get edit' do
    sign_in teachers(:teacherOne)
    get :edit, params: { id: clock_ins(:one).id }

    assert_response :success
  end
  
  test "should not create clock_in if already clocked in" do
    sign_in teachers(:teacherThree)
    post :create
  
    assert_equal 'Error creating the clock in.', flash[:notice]
    assert_redirected_to clock_ins_path
  end

  test "should create clock_in" do
    sign_in teachers(:teacherTwo)
    post :create
  
    assert_equal 'Clock in was successfully created.', flash[:notice]
    assert_redirected_to clock_ins_path
  end

  test "should end clock in" do
    sign_in teachers(:teacherFour)
    new_end = DateTime.current
    post :end, params: { id: clock_ins(:four).id }
  
    assert_redirected_to clock_ins_path
    teachers(:teacherFour).reload
    assert_equal false, teachers(:teacherFour).is_clocked_in
  end

  test "should not update another teacher's clock_in" do
    sign_in teachers(:teacherOne)
    clock_in = clock_ins(:two)
    new_start = DateTime.current
    patch :update, params: { id: clock_ins(:two).id, clock_in: { start: new_start } }
  
    assert_equal 'Unpermitted action.', flash[:notice]
    assert_redirected_to root_path
  end

  test "should update clock_in start" do
    sign_in teachers(:teacherOne)
    clock_in = clock_ins(:one)
    new_start = DateTime.current
    patch :update, params: { id: clock_ins(:one).id, clock_in: { start: new_start } }
  
    assert_redirected_to clock_ins_path
    clock_in.reload
    assert_equal new_start.to_i, clock_in.start.to_i
  end

  test "should update clock_in end" do
    sign_in teachers(:teacherOne)
    clock_in = clock_ins(:one)
    new_end = DateTime.current
    patch :update, params: { id: clock_ins(:one).id, clock_in: { end: new_end } }
  
    assert_redirected_to clock_ins_path
    clock_in.reload
    assert_equal new_end.to_i, clock_in.end.to_i
  end

  test "should not delete another teacher's clock_in" do
    sign_in teachers(:teacherTwo)
    clock_in = clock_ins(:one)
    delete :destroy, params: { id: clock_ins(:one).id }
  
    assert_equal 'Unpermitted action.', flash[:notice]
    assert_redirected_to root_path
  end

  test "should delete clock_in" do
    sign_in teachers(:teacherTwo)
    clock_in = clock_ins(:two)
    delete :destroy, params: { id: clock_ins(:two).id }
  
    assert_equal 'Clock in was successfully deleted.', flash[:notice]
    assert_redirected_to clock_ins_path
  end
end
