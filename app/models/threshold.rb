class Threshold < ApplicationRecord
  enum :sensor_type, { temperature: 0, humidity: 1, ammonia: 2 }

  validates :sensor_type, presence: true, uniqueness: true
end
