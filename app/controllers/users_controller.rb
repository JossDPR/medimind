class UsersController < ApplicationController
  before_action :set_user, only: [:home]
  def home
  end

  private

  def set_user
    @user = current_user
  end
end
