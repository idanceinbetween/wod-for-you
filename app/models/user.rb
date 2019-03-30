class User < ActiveRecord::Base
  has_many :routines
  has_many :exercises, through: :routines

  validates :name, presence: true

  def duration_sum
    self.exercises.sum(:duration).to_i
  end

  def my_custom_exercises
    Exercise.where(user_id: self.id)
  end

  def my_custom_exercises_hash_info_as_key
    hash = Hash.new
    my_custom_exercises.all.each do |o|
      key = "#{o.id}. #{o.name} (#{o.duration} mins) - #{o.description}"
      hash[key] = o.id
    end
    hash
  end

  def random_wod(max_time)
    delete_my_wod

    current_duration = 0
    until current_duration >= max_time
      selected = Exercise.all.sample
      if (current_duration += selected.duration) <= max_time
        Routine.create(user_id: self.id, exercise_id: selected.id)
      else
        current_duration -= selected.duration
      end
    end
    my_wod
  end

  def my_wod
    @my_wod = Routine.where(user_id: self.id)
  end

  def update_my_wod(selected_exercises_array)
    @my_wod = selected_exercises_array.each {|i| Routine.create(user_id: self.id, exercise_id: i)}
  end

  def delete_my_wod
    my_wod.destroy_all
  end

  def delete_myself
    User.where(id: self.id).destroy_all
  end

end
