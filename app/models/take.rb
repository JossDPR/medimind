class Take < ApplicationRecord
  belongs_to :planification

  validates :datetime, presence: true
  validates :planification_id, presence: true, numericality: { only_integer: true }
  validate :validate_planification_id

  private

  def validate_planification_id
    errors.add(:planification_id, "is invalid") unless Planification.exists?(self.planification_id)
  end
end
