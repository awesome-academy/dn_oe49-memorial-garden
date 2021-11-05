class CreateMemorials < ActiveRecord::Migration[6.1]
  def change
    create_table :memorials do |t|
      t.string :name, null: false
      t.integer :gender
      t.string :cause_of_death
      t.references :user, null: false, foreign_key: true
      t.string :background_song
      t.string :avatar
      t.string :relationship, null: false
      t.integer :privacy_type, null: false, default: 0
      t.text :biography

      t.timestamps
    end
  end
end
