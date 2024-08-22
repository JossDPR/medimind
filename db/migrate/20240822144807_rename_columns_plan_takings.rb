class RenameColumnsPlanTakings < ActiveRecord::Migration[7.1]
  def change
    rename_column :plan_takings, :planifications_id, :planification_id
    rename_column :plan_takings, :taking_periods_id, :taking_period_id
  end
end
