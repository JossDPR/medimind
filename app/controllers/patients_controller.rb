class PatientsController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :new]

  def home
  end
  def index
    authorize @patient
    @patients = @current_user.patients.all
  end

  def show
    authorize @patient
  end

  def new
    @patient= User.new
  end

  def create
    authorize @patient
    @patient = User.new(patient_params, role: "patient")
    @patient.tutors = current_user
    if @patient.save
      redirect_to patient_planifications_path(@patient)
    else
      render :new
    end
  end

  def update
    authorize @patient
    @patient.update(patient_params)
  end

  def destroy
    authorize @patient
  end

  private

  def set_user
    @user = current_user
  end

  def patient_params
    params.require(:user).permit(:first_name, :last_name, :phone_number)
  end

end