class CreateVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :youtube_id
      t.string :youtube_playlist_id
      t.boolean :featured

      t.timestamps
    end
  end
end
