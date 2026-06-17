class Zone < ApplicationRecord
  enum :status, { normal: 0, warning: 1, critical: 2 }

  belongs_to :shed
  has_one :farm, through: :shed
  has_many :sensors, dependent: :destroy
  has_many :alerts, dependent: :destroy

  validates :name, presence: true
end
