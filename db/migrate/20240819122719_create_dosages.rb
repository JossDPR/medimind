class CreateDosages < ActiveRecord::Migration[7.1]
  def change
    create_table :dosages do |t|
      t.string :label

      t.timestamps
    end
  end
end
