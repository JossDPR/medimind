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
    @planification = Planification.new
    @planification.patient_id = @patient.id
    if @planification.photo.attached? #=> true/false
      @planification.photo.purge
    end
    # @planification.photo = ???
    # attache new photo to planification
    # if @planification.save!
    #   redirect_to patient_planifications_path(@patient)
    #  else
    #   render 'new'
    #  end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def set_patient
    @patient = User.find(params[:patient_id])
  end
end
