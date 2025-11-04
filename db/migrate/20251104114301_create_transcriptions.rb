class CreateTranscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :transcriptions do |t|
      t.text :content, null: false
      t.text :summary
      t.string :status, default: 'pending', null: false

      t.timestamps
    end
  end
end
