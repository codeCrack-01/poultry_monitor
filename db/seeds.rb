puts "Seeding data..."

ActiveRecord::Base.transaction do
  # ── Thresholds ──────────────────────────────────────────────────────
  thresholds_data = {
    temperature: { warning_min: 18, warning_max: 26, critical_min: 12, critical_max: 30 },
    humidity:    { warning_min: 50, warning_max: 60, critical_min: 40, critical_max: 65 },
    ammonia:     { warning_min: 10, warning_max: 15, critical_min: 5,  critical_max: 20 }
  }

  thresholds_data.each do |type, limits|
    Threshold.find_or_create_by!(sensor_type: type) do |t|
      t.warning_min  = limits[:warning_min]
      t.warning_max  = limits[:warning_max]
      t.critical_min = limits[:critical_min]
      t.critical_max = limits[:critical_max]
    end
  end

  # ── Farms ───────────────────────────────────────────────────────────
  green_valley = Farm.create!(
    name: "Green Valley Farm",
    location: "123 Green Valley Rd, Springfield",
    status: :critical
  )

  sunrise = Farm.create!(
    name: "Sunrise Poultry",
    location: "456 Sunrise Blvd, Rivertown",
    status: :normal
  )

  hillside = Farm.create!(
    name: "Hillside Coop",
    location: "789 Hillside Dr, Meadowbrook",
    status: :warning
  )

  # ── Sheds ───────────────────────────────────────────────────────────
  gv_shed = green_valley.sheds.create!(name: "Shed 1")
  sr_shed = sunrise.sheds.create!(name: "Shed 1")
  hs_shed = hillside.sheds.create!(name: "Shed 1")

  now = Time.current

  # ── Helper to build a zone with sensors + readings ──────────────────
  zone_names = %w[A B C D]
  fan_labels = { "A" => ["Fan 1", "Fan 2"], "B" => ["Fan 1", "Fan 2"], "C" => ["Fan 1", "Fan 2", "Fan 3"], "D" => ["Fan 1", "Fan 2"] }

  build_zone = lambda do |shed, zone_name, status, readings_hash, offline_fans: []|
    zone = shed.zones.create!(name: zone_name, status: status)

    # temperature sensor
    temp_sensor = zone.sensors.create!(sensor_type: :temperature, label: "Temp Sensor #{zone_name}", status: :online)
    readings_hash[:temp].each { |v, t| temp_sensor.readings.create!(value: v, unit: "°C", recorded_at: t) }

    # humidity sensor
    humid_sensor = zone.sensors.create!(sensor_type: :humidity, label: "Humidity Sensor #{zone_name}", status: :online)
    readings_hash[:humid].each { |v, t| humid_sensor.readings.create!(value: v, unit: "%", recorded_at: t) }

    # ammonia sensor
    ammo_sensor = zone.sensors.create!(sensor_type: :ammonia, label: "Ammonia Sensor #{zone_name}", status: :online)
    readings_hash[:ammo].each { |v, t| ammo_sensor.readings.create!(value: v, unit: "ppm", recorded_at: t) }

    # fans
    fan_labels[zone_name].each_with_index do |label, idx|
      is_offline = offline_fans.include?(label)
      fan = zone.sensors.create!(sensor_type: :fan, label: label, status: is_offline ? :offline : :online)
      if is_offline
        fan.readings.create!(value: 0, unit: "rpm", recorded_at: now - 1.minute)
        fan.readings.create!(value: 1200, unit: "rpm", recorded_at: now - 30.minutes)
      else
        fan.readings.create!(value: 2400, unit: "rpm", recorded_at: now - 1.minute)
        fan.readings.create!(value: 2350, unit: "rpm", recorded_at: now - 15.minutes)
        fan.readings.create!(value: 2400, unit: "rpm", recorded_at: now - 30.minutes)
      end
    end
  end

  # ── Green Valley Farm Zones (matching demo) ─────────────────────────
  # Zone A: normal, 25°C, 54%
  build_zone.call(gv_shed, "A", :normal, {
    temp:  [[25.0, now - 2.minutes], [24.8, now - 15.minutes], [25.2, now - 30.minutes]],
    humid: [[54, now - 2.minutes], [55, now - 15.minutes], [54, now - 30.minutes]],
    ammo:  [[8, now - 2.minutes], [7, now - 15.minutes], [8, now - 30.minutes]]
  })

  # Zone B: warning, 30°C, 19 ppm
  build_zone.call(gv_shed, "B", :warning, {
    temp:  [[30.0, now - 2.minutes], [28.5, now - 15.minutes], [27.0, now - 30.minutes]],
    humid: [[62, now - 2.minutes], [60, now - 15.minutes], [58, now - 30.minutes]],
    ammo:  [[19, now - 2.minutes], [17, now - 15.minutes], [15, now - 30.minutes]]
  })

  # Zone C: critical, 34°C, 28 ppm, Fan 3 offline
  build_zone.call(gv_shed, "C", :critical, {
    temp:  [[34.2, now - 2.minutes], [33.0, now - 15.minutes], [31.5, now - 30.minutes]],
    humid: [[68, now - 2.minutes], [66, now - 15.minutes], [64, now - 30.minutes]],
    ammo:  [[28, now - 2.minutes], [26, now - 15.minutes], [24, now - 30.minutes]]
  }, offline_fans: ["Fan 3"])

  # Zone D: normal, 24°C, 52%
  build_zone.call(gv_shed, "D", :normal, {
    temp:  [[24.0, now - 2.minutes], [24.5, now - 15.minutes], [23.8, now - 30.minutes]],
    humid: [[52, now - 2.minutes], [53, now - 15.minutes], [51, now - 30.minutes]],
    ammo:  [[6, now - 2.minutes], [5, now - 15.minutes], [6, now - 30.minutes]]
  })

  # ── Sunrise Poultry Zones (all normal) ──────────────────────────────
  build_zone.call(sr_shed, "A", :normal, {
    temp:  [[24.5, now - 2.minutes], [24.0, now - 15.minutes], [23.5, now - 30.minutes]],
    humid: [[55, now - 2.minutes], [54, now - 15.minutes], [53, now - 30.minutes]],
    ammo:  [[8, now - 2.minutes], [7, now - 15.minutes], [6, now - 30.minutes]]
  })

  build_zone.call(sr_shed, "B", :normal, {
    temp:  [[23.8, now - 2.minutes], [24.2, now - 15.minutes], [23.0, now - 30.minutes]],
    humid: [[53, now - 2.minutes], [54, now - 15.minutes], [52, now - 30.minutes]],
    ammo:  [[7, now - 2.minutes], [6, now - 15.minutes], [7, now - 30.minutes]]
  })

  build_zone.call(sr_shed, "C", :normal, {
    temp:  [[24.2, now - 2.minutes], [24.8, now - 15.minutes], [24.0, now - 30.minutes]],
    humid: [[56, now - 2.minutes], [55, now - 15.minutes], [54, now - 30.minutes]],
    ammo:  [[6, now - 2.minutes], [5, now - 15.minutes], [6, now - 30.minutes]]
  })

  build_zone.call(sr_shed, "D", :normal, {
    temp:  [[23.5, now - 2.minutes], [23.0, now - 15.minutes], [23.8, now - 30.minutes]],
    humid: [[52, now - 2.minutes], [51, now - 15.minutes], [53, now - 30.minutes]],
    ammo:  [[5, now - 2.minutes], [6, now - 15.minutes], [5, now - 30.minutes]]
  })

  # ── Hillside Coop Zones (some warning, some normal) ─────────────────
  build_zone.call(hs_shed, "A", :normal, {
    temp:  [[26.0, now - 2.minutes], [25.5, now - 15.minutes], [25.0, now - 30.minutes]],
    humid: [[55, now - 2.minutes], [54, now - 15.minutes], [53, now - 30.minutes]],
    ammo:  [[10, now - 2.minutes], [9, now - 15.minutes], [8, now - 30.minutes]]
  })

  build_zone.call(hs_shed, "B", :warning, {
    temp:  [[29.8, now - 2.minutes], [28.0, now - 15.minutes], [27.0, now - 30.minutes]],
    humid: [[58, now - 2.minutes], [56, now - 15.minutes], [55, now - 30.minutes]],
    ammo:  [[18, now - 2.minutes], [16, now - 15.minutes], [14, now - 30.minutes]]
  })

  build_zone.call(hs_shed, "C", :normal, {
    temp:  [[25.0, now - 2.minutes], [24.5, now - 15.minutes], [25.5, now - 30.minutes]],
    humid: [[54, now - 2.minutes], [53, now - 15.minutes], [55, now - 30.minutes]],
    ammo:  [[9, now - 2.minutes], [8, now - 15.minutes], [9, now - 30.minutes]]
  })

  build_zone.call(hs_shed, "D", :normal, {
    temp:  [[24.8, now - 2.minutes], [24.0, now - 15.minutes], [25.2, now - 30.minutes]],
    humid: [[53, now - 2.minutes], [52, now - 15.minutes], [54, now - 30.minutes]],
    ammo:  [[7, now - 2.minutes], [8, now - 15.minutes], [7, now - 30.minutes]]
  })

  # ── Generator for Green Valley ──────────────────────────────────────
  gen = gv_shed.zones.first.sensors.create!(sensor_type: :generator, label: "Backup Generator", status: :online)
  gen.readings.create!(value: 87, unit: "%", recorded_at: now - 1.minute)
  gen.readings.create!(value: 85, unit: "%", recorded_at: now - 30.minutes)
  gen.readings.create!(value: 86, unit: "%", recorded_at: now - 60.minutes)

  # ── Alerts ───────────────────────────────────────────────────────────
  gv_zone_c = gv_shed.zones.find_by(name: "C")
  gv_zone_b = gv_shed.zones.find_by(name: "B")
  hs_zone_b = hs_shed.zones.find_by(name: "B")

  Alert.create!(
    farm: green_valley, zone: gv_zone_c, sensor: gv_zone_c.sensors.find_by(sensor_type: :ammonia),
    alert_type: "High Ammonia", severity: :critical, status: :active,
    message: "Zone C has high ammonia", value: 28,
    created_at: now - 15.minutes
  )
  Alert.create!(
    farm: green_valley, zone: gv_zone_c, sensor: gv_zone_c.sensors.find_by(sensor_type: :temperature),
    alert_type: "High Temperature", severity: :critical, status: :active,
    message: "Zone C is overheating", value: 34.2,
    created_at: now - 12.minutes
  )
  Alert.create!(
    farm: green_valley, zone: gv_zone_c, sensor: gv_zone_c.sensors.find_by(sensor_type: :fan, label: "Fan 3"),
    alert_type: "Fan Offline", severity: :critical, status: :active,
    message: "Fan 3 in Zone C is not running", value: 0,
    created_at: now - 18.minutes
  )
  Alert.create!(
    farm: green_valley, zone: gv_zone_c, sensor: gv_zone_c.sensors.find_by(sensor_type: :humidity),
    alert_type: "High Humidity", severity: :warning, status: :active,
    message: "Zone C humidity is elevated", value: 68,
    created_at: now - 25.minutes
  )
  Alert.create!(
    farm: hillside, zone: hs_zone_b, sensor: hs_zone_b.sensors.find_by(sensor_type: :temperature),
    alert_type: "Rising Temperature", severity: :warning, status: :active,
    message: "Zone B temperature rising", value: 29.8,
    created_at: now - 32.minutes
  )

  # Resolved alert
  sr_zone_a = sr_shed.zones.find_by(name: "A")
  Alert.create!(
    farm: sunrise, zone: sr_zone_a, sensor: sr_zone_a.sensors.find_by(sensor_type: :humidity),
    alert_type: "Humidity Spike Resolved", severity: :warning, status: :resolved,
    message: "Zone A returned to normal", value: 62,
    created_at: now - 2.hours, resolved_at: now - 1.hour
  )
end

puts "Seeding complete!"
puts "  Farms: #{Farm.count}"
puts "  Sheds: #{Shed.count}"
puts "  Zones: #{Zone.count}"
puts "  Sensors: #{Sensor.count}"
puts "  Readings: #{Reading.count}"
puts "  Thresholds: #{Threshold.count}"
puts "  Alerts: #{Alert.count}"
