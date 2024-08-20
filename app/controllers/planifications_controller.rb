class PlanificationsController < ApplicationController
  before_action :set_patient
  def index
    @planifications = Planification.where(patient_id: @patient)
  end

  def new
  end

  def create
    # @article.photo.attached? #=> true/false
    # @article.photo.purge
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
