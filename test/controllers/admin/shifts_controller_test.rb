require 'test_helper'

class Admin::ShiftsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get admin_shifts_show_url
    assert_response :success
  end

  test "should get edit" do
    get admin_shifts_edit_url
    assert_response :success
  end

end
