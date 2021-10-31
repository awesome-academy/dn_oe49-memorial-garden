class CreateAccessPrivacies < ActiveRecord::Migration[6.1]
  def change
    create_table :access_privacies do |t|
      t.references :user, null: false, foreign_key: true
      t.references :memorial, null: false, foreign_key: true

      t.timestamps
    end
    add_index :access_privacies, [:user_id, :memorial_id], unique: true
  end
end
