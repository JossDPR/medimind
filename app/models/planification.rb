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
  after_create :set_takes

  private

  def set_takes
    current_date = start_date
    while current_date <= end_date
      taking_periods.each do |e|
        case e.label
        when "Matin"
          Take.create(datetime: current_date.to_datetime + 5.hours, planification_id: id)
        when "Midi"
          Take.create(datetime: current_date.to_datetime + 10.hours, planification_id: id)
        when "Soir"
          Take.create(datetime: current_date.to_datetime + 15.hours, planification_id: id)
        end
      end
      current_date += frequency_days
    end
  end
end
