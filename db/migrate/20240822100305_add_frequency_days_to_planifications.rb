class AddFrequencyDaysToPlanifications < ActiveRecord::Migration[7.1]
  def change
    add_column :planifications, :frequency_days, :integer
  end
end
