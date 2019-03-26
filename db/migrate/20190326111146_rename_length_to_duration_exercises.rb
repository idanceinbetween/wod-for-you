class RenameLengthToDurationExercises < ActiveRecord::Migration[5.2]
  def change
    rename_column :exercises, :length, :duration
  end
end
