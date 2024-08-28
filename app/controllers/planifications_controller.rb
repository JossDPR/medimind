class PlanificationsController < ApplicationController
  before_action :set_patient, except: %i[destroy]
  before_action :set_planification, only: %i[confirm edit update destroy]
  require 'cloudinary'
  require 'cloudinary/uploader'
  require 'cloudinary/utils'


  def index
    @planifications = Planification.where(patient_id: @patient.id)
  end

  def photo
    base64_image = request.body.read
    open_ai_service = OpenAiSvc.new
    reponse = open_ai_service.analyser_boite(base64_image)

    ##Traitement du medicament (Ajout dans la db si non trouvé)
    if reponse != ""
      medic_name = reponse['name'].upcase + " " + reponse['dosage']
      type_medic = reponse['type']
      medic = Medication.find_or_create_by(name: medic_name)

      rechtype = type_medic.downcase.singularize + "(s)"
      dosage_type = Dosage.find_by(label: rechtype)

      respond_to do |format|
        format.json { render json: { message: "Médicament à planifier.", medication: medic, type: dosage_type }, status: :ok }
      end
    else
      # Fail lors de la récupération du médic
      respond_to do |format|
        format.json { render json: { error: "NOT_FOUND" }, status: :ok }
      end
    end






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
      respond_to do |format|
        format.json { render json: { message: "Planification updated successfully.", planification: @planification } }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: "Planif failed", planification: @planification } }
      end
    end
  end

  def destroy
    @patient = @planification.patient
    Planification.destroy(@planification.id)
    redirect_to patient_planifications_path(@patient)
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
