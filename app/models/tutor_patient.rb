class TutorPatient < ApplicationRecord
  belongs_to :tutor, class_name: 'User'
  belongs_to :patient, class_name: 'User'
end
