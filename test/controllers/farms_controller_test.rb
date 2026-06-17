require "test_helper"

class FarmsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get farms_url
    assert_response :success
  end

  test "should show farm" do
    get farm_url(farms(:green_valley))
    assert_response :success
  end

  test "should list all farms on index" do
    get farms_url
    assert_select "a", text: /Green Valley Farm/
    assert_select "a", text: /Sunrise Poultry/
  end
end
