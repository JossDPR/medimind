class Planification < ApplicationRecord
  belongs_to :medication
  belongs_to :dosage
  belongs_to :patient, :class_name => 'User'
  belongs_to :plan_taking
  has_many :taking_periods, through: :plan_taking
  has_many :takes
  has_one_attached :photo
end
