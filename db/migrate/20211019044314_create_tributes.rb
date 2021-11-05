class CreateTributes < ActiveRecord::Migration[6.1]
  def change
    create_table :tributes do |t|
      t.references :contribution, null: false, foreign_key: true
      t.text :eulogy, null: false
      t.references :rep_tribute, foreign_key: {to_table: :tributes}

      t.timestamps
    end
  end
end
