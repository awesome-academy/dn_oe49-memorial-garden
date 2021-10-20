class CreateAccessPrivacies < ActiveRecord::Migration[6.1]
  def change
    create_table :access_privacies do |t|
      t.references :user, null: false, foreign_key: true
      t.references :memorial, null: false, foreign_key: true

      t.timestamps
    end
  end
end
