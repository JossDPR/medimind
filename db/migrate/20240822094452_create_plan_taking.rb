class CreatePlanTaking < ActiveRecord::Migration[7.1]
  def change
    create_table :plan_takings do |t|
      t.references :planifications, null: false, foreign_key: true
      t.references :taking_periods, null: false, foreign_key: true
      t.timestamps
    end
  end
end
