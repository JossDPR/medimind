class PatientsController < ApplicationController
  def index
    @patients = @current_user.patients.all
  end

  def show
  end

  def create
    authorize @patient
  end

  def update
  end

  def destroy
  end

  private



end
