class CreateTakes < ActiveRecord::Migration[7.1]
  def change
    create_table :takes do |t|
      t.date :datetime
      t.references :planifications, null: false, foreign_key: true
      t.date :taken_date

      t.timestamps
    end
  end
end
