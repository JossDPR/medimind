# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# TutorPatient.destroy_all
# User.destroy_all

# puts 'creating users'
# user1 = User.create!(role: "tutor", first_name:"test_tutor", email: "tutor@test.com", password: "password")
# user2= User.create!(role: "patient", first_name: "test_patient", email: "patient@test.com", password: "password")

# puts 'User created'

# puts 'Creating table patient tutor'
# TutorPatient.create!(tutor_id: user1.id, patient_id: user2.id)
