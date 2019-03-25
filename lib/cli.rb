# require_relative '../app/models'

class CLI

  def greet
    puts 'ARE YOU READY TO GET THE BODY OF YOUR DREAMS?????????? YEAHHHHHHHH'
  end

  def get_name
    puts "Hi what is your name?"
    name = gets.chomp
    puts "Good morning #{name}, how many minutes would you like to workout today? Please enter a number between 1-60."
    duration = gets.chomp
    puts "OK. Would you like to do cardio or weights? Please input 0 for Cardio, 1 for Weights."
    type = gets.chomp
    type == 0 ? (cardio = true) : (cardio = false)
    puts "Great, #{name}, you'd like to workout for #{duration} minutes today, and you will be doing #{cardio}" ##needs checking
    User.create(name: name, duration: duration, :cardio? => cardio)
  end

  def give_wod
  end

  def user_select_wod
  end

  def update_wod
  end

  def delete_wod
  end

  def closest_gyms #Stretch goal
  end

  def music_suggest #Stretch goal
  end

  def share_wod #Stretch goal
  end

end
