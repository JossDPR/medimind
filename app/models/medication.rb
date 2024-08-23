class Medication < ApplicationRecord
  has_many :planifications

  validates :name, presence: true
end
