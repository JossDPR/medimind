class TutorPatient < ApplicationRecord
  belongs_to :tutor, class_name: 'User'
  belongs_to :patient, class_name: 'User'

  validates :tutor_id, presence: true
  validates :patient_id, presence: true
  validate :validate_tutor_id
  validate :validate_patient_id

  private

  def validate_tutor_id
    errors.add(:tutor_id, "is invalid") unless User.exists?(self.tutor_id)
  end

  def validate_patient_id
    errors.add(:patient_id, "is invalid") unless User.exists?(self.patient_id)
  end
end
