class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :planifications
  has_many :tutors_relation, class_name: 'TutorPatient', foreign_key: 'tutor_id'
  has_many :patients_relation, class_name: 'TutorPatient', foreign_key: 'patient_id'

  has_many :patients, through: :tutors_relation
  has_many :tutors, through: :patients_relation

  def tutor?
    self.role == 'tutor'
  end
end
