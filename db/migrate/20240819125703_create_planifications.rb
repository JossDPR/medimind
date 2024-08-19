class CreatePlanifications < ActiveRecord::Migration[7.1]
  def change
    create_table :planifications do |t|
      t.integer :quantity
      t.date :start_date
      t.date :end_date
      t.string :photo_key
      t.references :medication, null: false, foreign_key: true
      t.references :patient_id, null: false, foreign_key: { to_table: 'users' }
      t.references :dosage, null: false, foreign_key: true
      t.references :frequency, null: false, foreign_key: true

      t.timestamps
    end
  end
end
