class RemoveForeignColumnsPlanTakings < ActiveRecord::Migration[7.1]
  def change
    remove_column :plan_takings, :planification_id
    remove_column :plan_takings, :taking_period_id
  end
end
