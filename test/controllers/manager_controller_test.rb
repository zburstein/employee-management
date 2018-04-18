require 'test_helper'

class ManagerControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get manager_dashboard_url
    assert_response :success
  end

end
