class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def ui
    dosages = Dosage.all
    @dosage_labels = dosages.map do |dosage|
      dosage.label
    end
    medications = Medication.all
    @medications_name = medications.map do |medication|
      medication.name
    end
  end
end
