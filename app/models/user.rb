class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_create :default_tutor

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :planifications
  has_many :tutors_relation, class_name: 'TutorPatient', foreign_key: 'tutor_id'
  has_many :patients_relation, class_name: 'TutorPatient', foreign_key: 'patient_id'

  has_many :patients, through: :tutors_relation
  has_many :tutors, through: :patients_relation
  has_many :chats

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone_number, presence: true, length: { :minimum => 10, :maximum => 15 }

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
