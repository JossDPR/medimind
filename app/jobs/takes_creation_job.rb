class TakesCreationJob < ApplicationJob
  queue_as :default

  def perform(planification)
    planification.takes.destroy_all
    current_date = planification.start_date
    while current_date <= planification.end_date
      planification.taking_periods.each do |e|
        case e.label
        when "Matin"
          Take.create(datetime: current_date.to_datetime + 5.hours, planification_id: planification.id)
        when "Midi"
          Take.create(datetime: current_date.to_datetime + 10.hours, planification_id: planification.id)
        when "Soir"
          Take.create(datetime: current_date.to_datetime + 15.hours, planification_id: planification.id)
        end
      end
      current_date += planification.frequency_days
    end
  end
end
