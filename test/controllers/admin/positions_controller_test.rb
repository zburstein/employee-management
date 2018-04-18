require 'test_helper'

class Admin::PositionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_positions_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_positions_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_positions_edit_url
    assert_response :success
  end

end
