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
  after_create :set_takes

  private

  def set_takes
    # taking_periods va définir le datetime et un multiplicateur: pour chaque taking periods, on crée x takes
    # frequency_days va définir le nombre de fois et la date dans l'intervalle entre start_date et end_date
    # take.datetime
    # en partant de start_date, itérer sur taking periods pour créer un new take pour chaque période de prise
    # incrémenter start_date de frequency_days puis recréer un take pour la date suivante
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
