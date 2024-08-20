class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :update, :destroy]
  def index
    @patients = @current_user.patients.all
    authorize @patient
  end

  def show
    authorize @patient
  end

  def create
    @patient = User.new(role: patient)
    authorize @patient
  end

  def update
    @patient.update(patient_params)
    authorize @patient
  end

  def destroy
    authorize @patient
  end

  private

  def set_patient
    @patient = current_user
  end

  def patient_params
    params.require(:user).permit(:role, :first_name, :last_name, :phone_number)
  end

end
