class CreatePeriodicities < ActiveRecord::Migration[7.1]
  def change
    create_table :periodicities do |t|
      t.string :label

      t.timestamps
    end
  end
end
