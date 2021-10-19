class CreatePlacetimes < ActiveRecord::Migration[6.1]
  def change
    create_table :placetimes do |t|
      t.references :memorial, null: false, foreign_key: true
      t.string :location
      t.datetime :date
      t.boolean :is_born

      t.timestamps
    end
  end
end
