require 'test_helper'

class Admin::WeeklyPayrollsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_weekly_payrolls_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_weekly_payrolls_show_url
    assert_response :success
  end

end
