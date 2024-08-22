class AddForeignColumnsBackToPlanTakings < ActiveRecord::Migration[7.1]
  def change
    add_reference :plan_takings, :planification
    add_reference :plan_takings, :taking_period
  end
end
