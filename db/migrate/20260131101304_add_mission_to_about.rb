class AddMissionToAbout < ActiveRecord::Migration[8.1]
  def change
    add_column :about, :mission, :text
  end
end
