class RenameColumnsIdIdToId < ActiveRecord::Migration[7.1]
  def change
    rename_column :tutor_patients, :patient_id_id, :patient_id
    rename_column :tutor_patients, :tutor_id_id, :tutor_id
    rename_column :planifications, :patient_id_id, :patient_id
  end
end
