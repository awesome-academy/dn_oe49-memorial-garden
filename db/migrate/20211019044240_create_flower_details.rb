class CreateFlowerDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :flower_details do |t|
      t.string :name, null: false
      t.string :image
      t.string :meaning

      t.timestamps
    end
  end
end
