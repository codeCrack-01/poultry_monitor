class Sensor < ApplicationRecord
  enum :sensor_type, { temperature: 0, humidity: 1, ammonia: 2, fan: 3, generator: 4 }
  enum :status, { online: 0, offline: 1 }

  belongs_to :zone
  has_one :farm, through: :zone
  has_many :readings, dependent: :destroy
  has_many :alerts, dependent: :destroy

  validates :sensor_type, presence: true

  def latest_reading
    readings.order(recorded_at: :desc).first
  end
end
