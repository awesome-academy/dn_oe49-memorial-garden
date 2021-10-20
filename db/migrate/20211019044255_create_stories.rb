class CreateStories < ActiveRecord::Migration[6.1]
  def change
    create_table :stories do |t|
      t.references :contribution, null: false, foreign_key: true
      t.string :image
      t.string :content, null: false
      t.references :rep_story, foreign_key: {to_table: :stories}

      t.timestamps
    end
  end
end
