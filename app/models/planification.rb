class Planification < ApplicationRecord
  belongs_to :medication
  belongs_to :dosage
  belongs_to :frequency
  has_one_attached :photo
end
