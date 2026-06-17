require "test_helper"

class AlertsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get alerts_url
    assert_response :success
  end

  test "should show active alerts" do
    get alerts_url
    assert_response :success
    assert_select "div", text: /High temperature/
    assert_select "div", text: /High ammonia/
  end
end
