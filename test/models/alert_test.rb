require "test_helper"

class AlertTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    alert = alerts(:high_temp)
    assert alert.valid?
  end

  test "should require alert_type" do
    alert = alerts(:high_temp)
    alert.alert_type = nil
    assert_not alert.valid?
  end

  test "active scope returns only active alerts" do
    assert Alert.active.include?(alerts(:high_temp))
  end

  test "severity enum works" do
    assert alerts(:high_temp).critical?
    assert_equal "active", alerts(:high_temp).status
  end
end
