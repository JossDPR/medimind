class DropFrequencies < ActiveRecord::Migration[7.1]
  def change
    execute "DROP TABLE IF EXISTS periodicities CASCADE"
    execute "DROP TABLE IF EXISTS frequencies CASCADE"
  end
end
