class PlanTaking < ApplicationRecord
  belongs_to :taking_period
  belongs_to :planification

  # validates :taking_period_id, presence: true, numericality: { only_integer: true }
  # validate :validate_taking_period_id
  # validates :planification_id, presence: true, numericality: { only_integer: true }
  # validate :validate_planification_id

  private

  def validate_taking_period_id
    errors.add(:taking_period_id, "is invalid") unless TakingPeriod.exists?(self.taking_period_id)
  end

  def validate_planification_id
    errors.add(:planification_id, "is invalid") unless Planification.exists?(self.planification_id)
  end
end
