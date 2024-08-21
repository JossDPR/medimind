class PlanificationsController < ApplicationController
  before_action :set_patient

  def index
    @planifications = Planification.where(patient_id: @patient.id)
  end

  def new
    @planification = Planification.new
    @planification.patient_id = @patient.id
  end

  def create

  end

  def edit
  end

  def update
  end

  def destroy
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
