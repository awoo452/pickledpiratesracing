class RenameAboutsToAbout < ActiveRecord::Migration[8.0]
  def change
    rename_table :abouts, :about
  end
end
