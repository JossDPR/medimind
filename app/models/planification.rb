class Planification < ApplicationRecord
  belongs_to :medication
  belongs_to :dosage
  belongs_to :patient, :class_name => 'User'
  has_many :plan_takings
  has_many :taking_periods, through: :plan_takings
  has_many :takes
  has_one_attached :photo

  validates :quantity, presence: true, numericality: true
  validates :start_date, :end_date, presence: true
  validates :frequency_days, presence: true, inclusion: { in: [1, 2, 3, 4, 5, 6, 7] }
end
