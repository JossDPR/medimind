class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.string :message
      t.boolean :read
      t.references :user, null: false, foreign_key: true
      t.references :tutor_patient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
