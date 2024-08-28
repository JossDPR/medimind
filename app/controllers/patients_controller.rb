class PatientsController < ApplicationController
  before_action :set_patient, only: %i[cam edit update cam_patient photo]
  before_action :set_user, only: [:update, :destroy, :create, :new]

  def cam
    # authorize @patient
    @planification = Planification.new
  end

  def new
    @patient= User.new
  end



  def create
    # authorize @patient
    @patient = User.new(patient_params)
    @user.patients.push(@patient)
    if @patient.save
      redirect_to patient_planifications_path(@patient)
      flash[:notice] = "#{@patient.first_name} a été créé."
    else
      render :new, status: :unprocessable_entity
      flash[:alert] = "Les informations ne sont pas valides."
    end
  end

  def edit
  end

  def update
    # authorize @patient
    @patient.update(patient_params)
    if @patient.save!
      redirect_to patient_planifications_path(@patient)
      flash[:notice] = "#{@patient.first_name} a été mis à jour."
    else
      render :edit, status: :unprocessable_entity
      flash[:alert] = "Les modifications ne sont pas valides."
    end
  end

  def destroy
    # authorize @patient
  end

  private

  def set_user
    @user = current_user
  end

  def set_patient
    @patient = User.find(params[:id])
  end

  def patient_params
    params
      .require(:user)
      .permit(:first_name, :last_name, :phone_number, :email, :password, :password_confirmation)
      .with_defaults(role: "patient")
  end

end
