require 'test_helper'

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get employees_dashboard_url
    assert_response :success
  end

end
