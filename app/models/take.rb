class Take < ApplicationRecord
  belongs_to :planification

  validates :datetime, presence: true
end
