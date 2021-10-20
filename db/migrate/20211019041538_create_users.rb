class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.integer :gender
      t.string :email, null: false
      t.string :avatar
      t.integer :role, null: false, default: 0
      t.string :password_digest, null: false
      t.string :activate_digest
      t.string :reset_digest

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
