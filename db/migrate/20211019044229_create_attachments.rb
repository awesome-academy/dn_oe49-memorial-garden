class CreateAttachments < ActiveRecord::Migration[6.1]
  def change
    create_table :attachments do |t|
      t.references :contribution, null: false, foreign_key: true
      t.string :title
      t.integer :attachment_type, null: false
      t.string :photo
      t.string :audio
      t.string :video

      t.timestamps
    end
  end
end
