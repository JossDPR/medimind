class Planification < ApplicationRecord
  belongs_to :medication
  belongs_to :dosage
  belongs_to :patient, :class_name => 'User'
  has_many :plan_takings
  has_many :taking_periods, through: :plan_takings
  accepts_nested_attributes_for :plan_takings
  has_many :takes, dependent: :destroy
  has_one_attached :photo

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :start_date, :end_date, presence: true
  validates :end_date, comparison: { greater_than_or_equal_to: :start_date }
  validates :frequency_days, presence: true, numericality: { only_integer: true, greater_than: 0 }
  # after_save :set_takes_job
  after_commit :set_takes_job, on: %i[create update]

  private

  def set_takes_job
    TakesCreationJob.perform_later(self)
  end
end
