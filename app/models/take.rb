class Take < ApplicationRecord
  belongs_to :planification

  validates :datetime, presence: true

  def self.historique(patient)
    planification = Planification.where(patient_id: patient.id)
    takes = Take.where(planification_id: planification.ids, ).order(datetime: :asc)
    return takes
  end

  def self.current_take(patient)
    planification = Planification.where(patient_id: patient.id)
    takes = Take.where(planification_id: planification.ids)
    current_date = Time.now
    morning_takes = takes.where(datetime: current_date.beginning_of_day + 5.hours..current_date.beginning_of_day + 10.hours)
    noon_takes = takes.where(datetime: current_date.beginning_of_day + 10.hours..current_date.beginning_of_day + 15.hours)
    evening_takes = takes.where(datetime: current_date.beginning_of_day + 15.hours..current_date.beginning_of_day + 23.hours)

    case current_date.hour
    when 5..9
      return morning_takes
    when 10..14
      return noon_takes
    when 15..23
      return evening_takes
    end
  end

  def self.current_planification(patient)
    planification = Planification.where(patient_id: patient.id)
    take = Take.where(planification_id: planification.ids)
    return planification
  end
end
