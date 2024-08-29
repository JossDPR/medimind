class PatientHistoController < ApplicationController
  before_action :set_patient, only: %i[index]

  def index
    @takes = Take.historique(@patient).where('datetime < ?', DateTime.now)
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
