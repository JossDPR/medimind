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
    respond_to do |format|
      # format.html { redirect_to patient_planifications_path(@patient), notice: "Planification created successfully." }
      format.json { render json: { message: "Planification created successfully.", planification: @planification }, status: :created }
    end
    @planification = Planification.new(planification_params)
    @planification.patient_id = @patient.id
    if @planification.photo.attached? #=> true/false
      @planification.photo.purge
    end
    # raise
    # # @planification.photo = ???
    # # attache new photo to planification
    if @planification.save!
      redirect_to patient_planifications_path(@patient)
    else
      render
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def confirm
    @planification = Planification.new
    @planification.patient_id = @patient.id
  end

  private

  def set_patient
    if params[:patient_id]
      @patient = User.find(params[:patient_id])
    else
      @patient = current_user
    end
  end

  def planification_params
    params.require(:planification).permit(:photo, :medication_name, :medication_description, :begin_date, :end_date, :dosage_quantity, :dosage_label, :frequency_amount, :frequency_periodicity )
 end
end
