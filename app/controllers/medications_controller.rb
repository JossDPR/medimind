class MedicationsController < ApplicationController
  before_action :set_medication, only: %i[show edit update destroy]

  def index
    @medications = Medication.all
  end

  def show
  end

  def new
    @medication = Medication.new
  end

  def edit
  end

  def create
    @medication = Medication.new(params_medication)
    @medication.user_id = current_user.id
    if @medication.save
      redirect_to @medication, notice: "Medication was successfully created."
    else
      render :new
    end
  end

  def update
    if @medication.update!(params_medication)
      redirect_to @medication, notice: "Medication was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @medication.destroy
    redirect_to medications_path, notice: "Medication was successfully destroyed.", status: :see_other
  end

  private

  def set_medication
    @mesication = Medication.find(params[:id])
  end

  def params_medication
    params.require(:medication).permit(:name, :description, photos: [])
  end
end
