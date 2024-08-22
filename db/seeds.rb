# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


require 'cloudinary'
require 'open-uri'

puts 'Start - Destroy tables'
planifs = Planification.all
planifs.each do |planif|
  if planif.photo.attached?
    planif.photo.purge
  end
end
PlanTaking.destroy_all
Planification.destroy_all
Dosage.destroy_all
Medication.destroy_all
TutorPatient.destroy_all
User.destroy_all
Take.destroy_all
TakingPeriod.destroy_all
puts 'End - Destroy tables'

puts 'Start - Create Dosages'
dose_ampoule = Dosage.create!(label: "amploule(s)")
dose_application = Dosage.create!(label: "application(s)")
dose_capsule = Dosage.create!(label: "capsule(s)")
dose_comprime = Dosage.create!(label: "comprimé(s)")
dose_cc = Dosage.create!(label: "cuillère(s) à café")
dose_cs = Dosage.create!(label: "cuillère(s) à soupe")
dose_goute = Dosage.create!(label: "goute(s)")
dose_gramme = Dosage.create!(label: "gramme(s)")
dose_gelule = Dosage.create!(label: "gélule(s)")
dose_inhalation = Dosage.create!(label: "inhalation(s)")
dose_injection = Dosage.create!(label: "injection(s)")
dose_milligramme = Dosage.create!(label: " milligramme(s)")
dose_millilitre = Dosage.create!(label: "millilitre(s)")
dose_piece = Dosage.create!(label: "pièce(s)")
dose_portion = Dosage.create!(label: "portion(s)")
dose_sachet = Dosage.create!(label: "sachet(s)")
dose_spray = Dosage.create!(label: "spray")
dose_suppositoire = Dosage.create!(label: "suppositoire(s)")
dose_unite = Dosage.create!(label: "unité(s)")
puts 'End - Create Dosages'

puts 'Start - Create Taking Periods'
period_matin = TakingPeriod.create!(label: "Matin")
period_midi = TakingPeriod.create!(label: "Midi")
period_soir = TakingPeriod.create!(label: "Soir")
puts 'End - Create Taking Periods'

puts 'Start - Create Medications'
medic1 = Medication.create!(name: "Metformine", description: "")
medic2 = Medication.create!(name: "Ozempic", description: "")
medic3 = Medication.create!(name: "Doliprane", description: "")
puts 'End - Create Medications'

puts 'Start - Create Users'
tutor = User.create!(email: "tutor@test.com", password: "password", role: "tutor", first_name: "tutor", last_name: "Tuteur", phone_number: "05 61 00 00 00")
patient = User.create!(email: "patient@test.com", password: "password", role: "patient", first_name: "patient1", last_name: "Patient1", phone_number: "05 61 99 99 99")
puts 'End - Create Users'

puts 'Start - Create TutorPatients'
TutorPatient.create!(tutor_id: tutor.id, patient_id: patient.id)
puts 'End - Create TutorPatients'

puts 'Start - Create Planifications'
planif1 = Planification.create!(patient_id: patient.id, start_date: "19/08/2024", end_date: "", medication_id: medic1.id, quantity: 1, dosage_id: dose_comprime.id, frequency_days: 1, description: "Prise de cachet journalière (Matin/Midi/Soir)")
planif1.photo.attach(io: URI.open('https://asset.cloudinary.com/dw9vzaips/91882ab24984f1b7bd1ed0a2b8f350ed'), filename: "medoc", content_type: "image/jpg")
planTaking11 = PlanTaking.create!(planifications_id: planif1.id, taking_periods_id: period_matin.id)
planTaking12 = PlanTaking.create!(planifications_id: planif1.id, taking_periods_id: period_midi.id)
planTaking13 = PlanTaking.create!(planifications_id: planif1.id, taking_periods_id: period_soir.id)

planif2 = Planification.create!(patient_id: patient.id, start_date: "19/08/2024", end_date: "", medication_id: medic2.id, quantity: 1, dosage_id: dose_injection.id, frequency_days: 1, description: "Prise de cachet journalière seulement le matin")
planif2.photo.attach(io: URI.open('https://asset.cloudinary.com/dw9vzaips/91882ab24984f1b7bd1ed0a2b8f350ed'), filename: "medoc", content_type: "image/jpg")
planTaking21 = PlanTaking.create!(planifications_id: planif2.id, taking_periods_id: period_matin.id)

planif3 = Planification.create!(patient_id: patient.id, start_date: "19/08/2024", end_date: "24/08/2024", medication_id: medic3.id, quantity: 1, dosage_id: dose_comprime.id, frequency_days: 7, description: "Prise de cachet une fois par semaine le midi")
planif3.photo.attach(io: URI.open('https://asset.cloudinary.com/dw9vzaips/91882ab24984f1b7bd1ed0a2b8f350ed'), filename: "medoc", content_type: "image/jpg")
planTaking31 = PlanTaking.create!(planifications_id: planif3.id, taking_periods_id: period_midi.id)
puts 'End - Create Planifications'
