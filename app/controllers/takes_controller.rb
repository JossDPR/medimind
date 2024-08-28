class TakesController < ApplicationController
  before_action :set_patient, only: %i[index]
  # before_action :set_take, only: %i[cam_patient, photo]

  def index
    @takes = Take.current_take(@patient)
  end

  def cam_patient
    @take = Take.find(params[:id])
  end

  def photo
    @take = Take.find(params[:id])
    base64_image = request.body.read
    @planif = @take.planification
    open_ai_service = OpenAiSvc.new
    @resultat = open_ai_service.comparer_photos(base64_image, @planif.medication.name)

    if @resultat === "Fail"
      respond_to do |format|
        format.json { render json: { error: "NOT_FOUND" }, status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: { resultat: @resultat }, status: :ok }
      end
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

  # def set_take
  #   @take = Take.find(params[:id])
  # end
end
