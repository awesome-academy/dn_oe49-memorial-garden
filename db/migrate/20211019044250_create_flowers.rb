class CreateFlowers < ActiveRecord::Migration[6.1]
  def change
    create_table :flowers do |t|
      t.references :contribution, null: false, foreign_key: true
      t.integer :type, null: false, default: 0
      t.text :message

      t.timestamps
    end
  end
end
