class AddStartSecondsToVideos < ActiveRecord::Migration[8.1]
  def change
    add_column :videos, :start_seconds, :integer
  end
end
