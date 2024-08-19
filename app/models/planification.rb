class Planification < ApplicationRecord
  belongs_to :medication
  belongs_to :dosage
  belongs_to :frequency
end
