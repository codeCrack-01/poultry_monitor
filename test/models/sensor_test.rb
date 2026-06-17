require "test_helper"

class SensorTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    sensor = sensors(:gv_temp)
    assert sensor.valid?
  end

  test "should respond to latest_reading" do
    sensor = sensors(:gv_temp)
    assert_respond_to sensor, :latest_reading
  end

  test "latest_reading returns most recent reading" do
    sensor = sensors(:gv_temp)
    latest = sensor.latest_reading
    assert_equal readings(:gv_temp_reading), latest
  end

  test "sensor_type enum works" do
    assert sensors(:gv_temp).temperature?
    assert sensors(:gv_ammonia).ammonia?
  end
end
