class CreateTutorPatients < ActiveRecord::Migration[7.1]
  def change
    create_table :tutor_patients do |t|
      t.references :tutor_id, null: false, foreign_key: { to_table: 'users' }
      t.references :patient_id, null: false, foreign_key: { to_table: 'users' }

      t.timestamps
    end

  end
end
