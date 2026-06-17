class Reading < ApplicationRecord
  belongs_to :sensor

  validates :value, presence: true
  validates :recorded_at, presence: true
end
