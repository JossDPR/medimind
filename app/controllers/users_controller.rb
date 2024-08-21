class UsersController < ApplicationController
  before_action :set_user, only: [:home]
  def home
    @patients = @user.patients
  end

  private

  def set_user
    @user = current_user
  end
end
