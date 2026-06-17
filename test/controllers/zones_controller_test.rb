require "test_helper"

class ZonesControllerTest < ActionDispatch::IntegrationTest
  test "should show zone" do
    get zone_url(zones(:gv_zone_c))
    assert_response :success
  end

  test "should show zone name on page" do
    get zone_url(zones(:gv_zone_c))
    assert_select "div", text: /Zone C/
  end
end
