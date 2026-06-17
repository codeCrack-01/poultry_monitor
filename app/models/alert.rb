class Alert < ApplicationRecord
  enum :severity, { warning: 0, critical: 1 }
  enum :status, { active: 0, resolved: 1 }

  belongs_to :farm
  belongs_to :zone, optional: true
  belongs_to :sensor, optional: true

  validates :alert_type, presence: true
  validates :severity, presence: true

  scope :active, -> { where(status: :active) }
  scope :by_severity, -> { order(severity: :desc, created_at: :desc) }
end
