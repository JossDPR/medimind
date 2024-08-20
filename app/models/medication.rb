class Medication < ApplicationRecord
  has_many :planifications
  has_many_attached :photos
end
