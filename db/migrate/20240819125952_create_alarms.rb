class CreateAlarms < ActiveRecord::Migration[7.1]
  def change
    create_table :alarms do |t|
      t.datetime :datetime
      t.references :planification, null: false, foreign_key: true

      t.timestamps
    end
  end
end
