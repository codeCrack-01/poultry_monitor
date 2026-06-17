class Shed < ApplicationRecord
  belongs_to :farm
  has_many :zones, dependent: :destroy

  validates :name, presence: true
end
