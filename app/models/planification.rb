class Planification < ApplicationRecord
  belongs_to :medication
  belongs_to :dosage
  belongs_to :patient, :class_name => 'User'
  has_one_attached :photo
end
