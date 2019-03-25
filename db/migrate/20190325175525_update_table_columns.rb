class UpdateTableColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :cardio?
    remove_column :exercises, :duration
    add_column :exercises, :description, :string
    add_column :exercises, :length, :integer
  end
end
