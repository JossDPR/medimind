class RemoveColsToPlanifications < ActiveRecord::Migration[7.1]
  def change
    remove_column :planifications, :photo_key, :string
    remove_column :planifications, :photo, :string
  end
end
