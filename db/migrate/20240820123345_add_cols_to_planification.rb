class AddColsToPlanification < ActiveRecord::Migration[7.1]
  def change
    add_column :planifications, :description, :string
    add_column :planifications, :photo, :string
  end
end
