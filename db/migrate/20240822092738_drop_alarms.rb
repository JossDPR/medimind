class DropAlarms < ActiveRecord::Migration[7.1]
  def change
    execute "DROP TABLE IF EXISTS alarms CASCADE"
  end
end
