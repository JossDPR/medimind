class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_create :default_tutor

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def default_tutor
    self.role ||= "tutor"
  end

  def tutor?
    self.role == "tutor"
  end

  def patient?
    self.role == "patient"
  end
end
