class Planification < ApplicationRecord
  belongs_to :medication
  belongs_to :dosage
  belongs_to :patient, :class_name => 'User'
  has_many :plan_takings
  has_many :taking_periods, through: :plan_takings
  accepts_nested_attributes_for :plan_takings
  has_many :takes
  has_one_attached :photo

  validates :quantity, presence: true, numericality: true
  validates :start_date, :end_date, presence: true
  validates :frequency_days, presence: true, inclusion: { in: [1, 2, 3, 4, 5, 6, 7] }
  validates :patient_id, presence: true
  validate :validate_patient_id
  validates :medication_id, presence: true, numericality: { only_integer: true }
  validate :validate_medication_id
  validates :dosage_id, presence: true, numericality: { only_integer: true }
  validate :validate_dosage_id

  private

  def validate_patient_id
    errors.add(:patient_id, "is invalid") unless User.exists?(self.patient_id)
  end

  def validate_medication_id
    errors.add(:medication_id, "is invalid") unless Medication.exists?(self.medication_id)
  end

  def validate_dosage_id
    errors.add(:dosage_id, "is invalid") unless Dosage.exists?(self.dosage_id)
  end

end
