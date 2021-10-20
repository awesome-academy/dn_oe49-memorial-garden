class CreateContributions < ActiveRecord::Migration[6.1]
  def change
    create_table :contributions do |t|
      t.references :memorial, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :contribution_type, null: false
      t.string :relationship, null: false

      t.timestamps
    end
  end
end
