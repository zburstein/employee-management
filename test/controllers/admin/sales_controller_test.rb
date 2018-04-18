require 'test_helper'

class Admin::SalesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get admin_sales_edit_url
    assert_response :success
  end

  test "should get new" do
    get admin_sales_new_url
    assert_response :success
  end

end
