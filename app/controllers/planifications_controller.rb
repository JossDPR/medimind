class PlanificationsController < ApplicationController
  before_action :set_patient
  before_action :set_planification, only: %i[confirm edit update]
  require 'cloudinary'
  require 'cloudinary/uploader'
  require 'cloudinary/utils'


  def index
    @planifications = Planification.where(patient_id: @patient.id)
    # @take = Take.where(planification_id: @planification.id)
    # @current_time = DateTime.now
    # @morning_start = DateTime.now.beginning_of_day + 5.hours
    # @morning_end = DateTime.now.beginning_of_day + 10.hours
    # @noon_start = DateTime.now.beginning_of_day + 10.hours
    # @noon_end = DateTime.now.beginning_of_day + 15.hours
    # @evening_start = DateTime.now.beginning_of_day + 15.hours
    # @evening_end = DateTime.now.beginning_of_day + 23.hours
  end

  def new
    @planification = Planification.new
    @planification.patient_id = @patient.id
  end

  def create

    @planification = Planification.new(planification_params)
    @planification.patient_id = @patient.id
    if @planification.photo.attached? #=> true/false
      @planification.photo.purge
    end
    # photo=params[:file]
    # cloudinary_response = Cloudinary::Uploader.upload(photo.tempfile.path)

    @planification.photo.attach(params[:file])

    if @planification.save!
      respond_to do |format|
        # format.html { redirect_to patient_planifications_path(@patient), notice: "Planification created successfully." }
        format.json { render json: { message: "Planification created successfully.", planification: @planification }, status: :created }
        # data-camera-url-value=<%="#{confirm_planification_path(@planification)}
      end
    else
      respond_to do |format|
        # format.html { redirect_to patient_planifications_path(@patient), notice: "Planification created successfully." }
        format.json { render json: { errors: "Planif failed", planification: @planification }, status: :created }
      end
    end
  end

  def edit
  end

  def update
    if @planification.update!(planification_params)
      redirect_to  confirm_planification_path(@planification)
    else
      render :edit
    end
  end

  def destroy
  end

  def confirm
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
    params.require(:planification).permit(:photo, :medication_id, :description, :start_date, :end_date, :dosage_id, :frequency_days, :quantity, :patient_id, taking_period_ids:[])
 end

 def set_planification
  @planification = Planification.find(params[:id])
 end
end
