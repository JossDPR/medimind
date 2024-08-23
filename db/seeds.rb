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
dose_ampoule = Dosage.create!(label: "ampoule(s)")
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
medic1 = Medication.create!(name: "Metformine", description: "Gros cachet...")
medic2 = Medication.create!(name: "Ozempic", description: "Stylo piqure, petite aiguille mais ça pique quand même")
medic3 = Medication.create!(name: "Doliprane", description: "A prendre en cas de douleurs")
puts 'End - Create Medications'

puts 'Start - Create Users'
tutor = User.create!(email: "tutor@test.com", password: "password", role: "tutor", first_name: "tutor", last_name: "Tuteur", phone_number: "05 61 00 00 00")
patient = User.create!(email: "patient@test.com", password: "password", role: "patient", first_name: "patient1", last_name: "Patient1", phone_number: "05 61 99 99 99")
puts 'End - Create Users'

puts 'Start - Create TutorPatients'
TutorPatient.create!(tutor_id: tutor.id, patient_id: patient.id)
puts 'End - Create TutorPatients'

puts 'Start - Create Planifications'
planif1 = Planification.new(patient_id: patient.id, start_date: "19/08/2024", end_date: "19/11/2024", medication_id: medic1.id, quantity: 1, dosage_id: dose_comprime.id, frequency_days: 1, description: "Prise de cachet journalière (Matin/Midi/Soir), pendant 3 mois")
file1 = URI.open("https://cdn.pim.mesoigner.fr/mesoigner/6e704e85abf8557ac1a0df9eaf559fe2/mesoigner-thumbnail-1000-1000-inset/747/963/metformine-mylan-pharma-1000-mg-comprime-pellicule-secable.webp?_gl=1*161jgmi*_ga*MTU1NTc3NTg1NS4xNzI0MzMyMTE4*_ga_7HLHFDJBJ4*MTcyNDMzMjEyMS4xLjAuMTcyNDMzMjEyMS4wLjAuMA..*_ga_QQCTP1QGD8*MTcyNDMzMjEyMS4xLjAuMTcyNDMzMjEyMS4wLjAuMA..*_ga_DMKLHSGSV7*MTcyNDMzMjEyMS4xLjAuMTcyNDMzMjEyMS4wLjAuMA..")
p uploaded_file1 = Cloudinary::Uploader.upload(file1.path, transformation: [{fetch_format: "webp"}])
p planif1.photo.attach(io: URI.open(uploaded_file1['url']), filename: medic1.name, content_type: "image/webp")
planif1.taking_periods = [period_matin, period_midi, period_soir]
planif1.save!
# planTaking11 = PlanTaking.create!(planification_id: planif1.id, taking_period_id: period_matin.id)
# planTaking12 = PlanTaking.create!(planification_id: planif1.id, taking_period_id: period_midi.id)
# planTaking13 = PlanTaking.create!(planification_id: planif1.id, taking_period_id: period_soir.id)

planif2 = Planification.new(patient_id: patient.id, start_date: "19/08/2024", end_date: "19/09/2024", medication_id: medic2.id, quantity: 1, dosage_id: dose_injection.id, frequency_days: 1, description: "Prise de cachet journalière seulement le matin, pendant 1 mois")
file2 = URI.open("https://www.novomedlink.com/content/dam/novonordisk/novomedlink/new/diabetes/products/treatments/ozempic/now-available/Ozempic_EHR_blue.png/jcr:content/renditions/original")
p uploaded_file2 = Cloudinary::Uploader.upload(file2.path, transformation: [{fetch_format: "webp"}])
p planif2.photo.attach(io: URI.open(uploaded_file2['url']), filename: medic2.name, content_type: "image/webp")
planif1.taking_periods = [period_matin]
planif2.save!
# planTaking21 = PlanTaking.create!(planification_id: planif2.id, taking_period_id: period_matin.id)

planif3 = Planification.new(patient_id: patient.id, start_date: "19/08/2024", end_date: "19/10/2024", medication_id: medic3.id, quantity: 1, dosage_id: dose_comprime.id, frequency_days: 7, description: "Prise de cachet une fois par semaine le midi, pendant 2 mois")
file3 = URI.open("https://www.pharma-medicaments.com/wp-content/uploads/2022/01/3595583-768x509.jpg")
p uploaded_file3 = Cloudinary::Uploader.upload(file3.path, transformation: [{fetch_format: "webp"}])
p planif3.photo.attach(io: URI.open(uploaded_file3['url']), filename: medic3.name, content_type: "image/webp")
planif1.taking_periods = [period_midi]
planif3.save!
# planTaking31 = PlanTaking.create!(planification_id: planif3.id, taking_period_id: period_midi.id)
puts 'End - Create Planifications'
