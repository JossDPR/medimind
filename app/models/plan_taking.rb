class PlanTaking < ApplicationRecord
  belongs_to :taking_period
  belongs_to :planification

  private

  def validate_taking_period_id
    errors.add(:taking_period_id, "is invalid") unless TakingPeriod.exists?(self.taking_period_id)
  end

  def validate_planification_id
    errors.add(:planification_id, "is invalid") unless Planification.exists?(self.planification_id)
  end
end
