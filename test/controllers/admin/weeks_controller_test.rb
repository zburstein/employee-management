require 'test_helper'

class Admin::WeeksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_weeks_index_url
    assert_response :success
  end

end
