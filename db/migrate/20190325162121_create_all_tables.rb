class CreateAllTables < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :duration
      t.boolean :cardio?
    end

    create_table :exercises do |t|
      t.string :name
      t.integer :duration
    end

    create_table :routines do |t|
      t.integer :user_id
      t.integer :exercise_id
    end
  end
end
