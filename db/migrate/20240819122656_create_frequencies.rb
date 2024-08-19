class CreateFrequencies < ActiveRecord::Migration[7.1]
  def change
    create_table :frequencies do |t|
      t.integer :amount
      t.references :periodicity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
