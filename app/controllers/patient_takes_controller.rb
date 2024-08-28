class PatientTakesController < ApplicationController
  before_action :set_patient, only: %i[index]

  def index
    @takes = Take.current_take(@patient).where(taken_date: nil)
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
