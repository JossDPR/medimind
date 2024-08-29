class PatientHistoController < ApplicationController
  before_action :set_patient, only: %i[index create]
  require 'json'
  def index
    @takes = Take.historique(@patient).where('datetime < ?', DateTime.now)
  end

  def create
    if params[:patient_id].present?
      if params[:histo].present?
        start_date = params[:histo][:start_date]
        end_date = params[:histo][:end_date]
        takes = Take.historique(@patient).where(datetime: start_date..end_date).order(datetime: :asc)
        puts "NB Takes : #{takes.count}"
        respond_to do |format|
          format.json { render json: { resultat: takes }, status: :ok }
        end

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
