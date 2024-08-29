class PatientTakesController < ApplicationController
  before_action :set_patient, only: %i[index]

  def index
    @takes = Take.current_take(@patient).where(taken_date: nil)
    if current_user.tutor?
      @tutor_patient_relation = TutorPatient.where(["patient_id = ? and tutor_id = ?", @patient.id, current_user.id])
    else
      @tutor_patient_relation = TutorPatient.where(patient_id: @patient.id)
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
