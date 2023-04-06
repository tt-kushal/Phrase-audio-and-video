class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.string :url
      t.string :transcript_id
      t.string :status

      t.timestamps
    end
  end
end
