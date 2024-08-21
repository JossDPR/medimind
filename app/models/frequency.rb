class Frequency < ApplicationRecord
  belongs_to :periodicity
  has_many :planifications
end
