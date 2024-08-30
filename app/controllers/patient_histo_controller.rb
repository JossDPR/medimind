class PatientHistoController < ApplicationController
  before_action :set_patient, only: %i[index create]
  require 'json'
  require 'date'
  def index
    @takes = Take.historique(@patient).where('datetime < ?', DateTime.now)
  end

  def create
    if params[:patient_id].present?
      start_date = params[:startDate]
      end_date = params[:endDate]
      takes = Take.historique(@patient).where(datetime: start_date..end_date).order(datetime: :asc)

      retourhtml = ""
      previous_date = nil
      previous_moment = nil
      takes.each do |take|

        if previous_date != take.datetime.to_date
          retourhtml += "<p class=\"histodat\">#{take.datetime.strftime('%d/%m/%Y')}</p>"
        end

        current_moment = 'Matin' if (5..9).include?(take.datetime.hour)
        current_moment = 'Midi' if (10..14).include?(take.datetime.hour)
        current_moment = 'Soir' if (15..23).include?(take.datetime.hour)

        if current_moment && current_moment != previous_moment
          retourhtml += "<p class=\"histomom\"> #{current_moment}</p>"
        end
        retourhtml += '<div class="cardhisto">'

        addclass = ""
        if take.taken_date.nil?
          addclass = 'nottaken'
        end
        retourhtml += "<div class=\"icon-container #{addclass}\"></div><div class=\"message-text-container\">"
        retourhtml += "<p class=\"message-text\">#{take.planification.medication.name}</p></div></div>"

        previous_date = take.datetime.to_date
        previous_moment = current_moment
      end

      respond_to do |format|
        format.text { render plain: retourhtml, status: :ok, content_type: 'text/plain' }
      end
    end
  end

  private

  def set_patient
    if params[:patient_id]
      @patient = User.find(params[:patient_id])
    else
      @patient = current_user
    end
  end
end
