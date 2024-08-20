class Planification < ApplicationRecord
  belongs_to :medication
  belongs_to :dosage
  belongs_to :frequency
  belongs_to :patient, :class_name => 'User'
  has_many :alarms, dependent: :destroy
  # has_one_attached :photo
end
