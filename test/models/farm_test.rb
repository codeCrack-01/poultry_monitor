require "test_helper"

class FarmTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    farm = farms(:green_valley)
    assert farm.valid?
  end

  test "should have many sheds" do
    farm = farms(:green_valley)
    assert_respond_to farm, :sheds
  end

  test "should have many zones through sheds" do
    farm = farms(:green_valley)
    assert_respond_to farm, :zones
  end

  test "should have many alerts" do
    farm = farms(:green_valley)
    assert_respond_to farm, :alerts
  end

  test "should require name" do
    farm = Farm.new(status: :normal)
    assert_not farm.valid?
  end

  test "status enum works" do
    assert_equal "normal", farms(:sunrise).status
    assert_equal "critical", farms(:green_valley).status
  end
end
