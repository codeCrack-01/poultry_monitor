class Farm < ApplicationRecord
  enum :status, { normal: 0, warning: 1, critical: 2 }

  has_many :sheds, dependent: :destroy
  has_many :zones, through: :sheds
  has_many :alerts, dependent: :destroy

  validates :name, presence: true
end
