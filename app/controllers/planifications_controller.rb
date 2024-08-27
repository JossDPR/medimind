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
    # open_ai_service = OpenAiSvc.new  # Crée une instance de la classe OpenAiSvc
    # photo1 = "https://www.pharma-medicaments.com/wp-content/uploads/2022/01/3595583-768x509.jpg"
    # photo2 = "https://images.lasante.net/2056-141093-large.webp"
    # resultat = open_ai_service.comparer_photos(photo1, photo2)

    # ordo = "https://static.allodocteurs.fr/btf-11-31157-default-660/b48bfa025a4c2f0951ceb2481b8f0e1b/media.jpg"
    # resultat = open_ai_service.lecture_ordonance(ordo)

    # Analyse la photo de la boite, l'ajoute à la DB si besoin et renvoi la ref en DB
    # medic = open_ai_service.analyser_boite(photo2)
    # medic = open_ai_service.analyser_boite(ficb64)

    # medic = open_ai_service.analyser_boite(photo_boite)
    #
    base64_image = request.body.read
    open_ai_service = OpenAiSvc.new
    medic = open_ai_service.analyser_boite(base64_image)

    if medic === "Fail"
      respond_to do |format|
        format.json { render json: { error: "NOT_FOUND" }, status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: { message: "Médicament à planifier.", medication: medic }, status: :ok }
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
      redirect_to  confirm_planification_path(@planification)
    else
      render :edit
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
