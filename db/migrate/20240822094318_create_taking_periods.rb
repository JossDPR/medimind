class CreateTakingPeriods < ActiveRecord::Migration[7.1]
  def change
    create_table :taking_periods do |t|
      t.string :label

      t.timestamps
    end
  end
end
