class ModifyColumnsInTakes < ActiveRecord::Migration[7.1]
  def change
    remove_column :takes, :planifications_id
    add_reference :takes, :planification, null: false
    change_column :takes, :datetime, :datetime
    change_column :takes, :taken_date, :datetime
  end
end
