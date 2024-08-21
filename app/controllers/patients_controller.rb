class PatientsController < ApplicationController
  before_action :set_user, only: [:home, :show, :update, :destroy, :create, :new]

  def home
    # authorize @patient
  end

  def show
    # authorize @patient
  end

  def new
    @patient= User.new
  end

  def create
    # authorize @patient
    @patient = User.new(patient_params)
    @user.patients.push(@patient)
    raise
    if @patient.save
      redirect_to patient_planifications_path(@patient)
    else
      render :new
    end
  end

  def update
    # authorize @patient
    @patient.update(patient_params)
    redirect_to patient_path(@patient)
  end

  def destroy
    # authorize @patient
  end

  private

  def set_user
    @user = current_user
  end

  def patient_params
    params
      .require(:user)
      .permit(:first_name, :last_name, :phone_number, :email, :password, :password_confirmation)
      .with_defaults(role: "patient")
  end

end
