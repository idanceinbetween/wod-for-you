require 'pry'
require 'TTY'

class CLI

  def initialize
    @prompt = TTY::Prompt.new
  end

  def greet
    puts 'ARE YOU READY TO GET THE BODY OF YOUR DREAMS?????????? YEAHHHHHHHH'
  end

  def get_name
    @name = @prompt.ask("What is your first name?") do |q|
        q.required true
        q.validate /\A\w+\Z/
    end
  end

  def main_menu
    @prompt.select("What would you like to do today?") do |menu|
      menu.enum '.'
      menu.choice "Add Custom Exercise", "make_custom_exercise"
      menu.choice "View your last WOD", "confirm_duration"
      menu.choice "Workout now!", "confirm_duration"
    end
  end

  def start
    greet
    get_name
    main_menu
    # confirm_duration
    # make_custom_exercise
    # view_my_custom_exercises
  end

  def confirm_duration
    if User.find_by(name: @name)
      @user = User.find_by(name: @name)
      @duration = @user.exercises.sum(:duration)
      puts "Welcome back #{@name}. Your last WOD was #{@duration} mins."
      answer1 = @prompt.yes?("Would you like to change the duration today?")#programme better if not y/n
      if answer1 == true
        destroy_my_routine
        @duration = @prompt.ask("How long would you like to workout today, in minutes? (MINIMUM 5 MINS, DONT BE LAZY!)")
        puts "Thanks, let me run a get_random_wod for you right now, hang on."
        get_random_wod
      else
        puts "Here is your WOD from the previous visit:"
        User.find_by(name: @name).exercises.each_with_index do |o,i|
          puts "#{i+1}. #{o.name} (#{o.duration} mins) \n #{o.description}"
        end
        answer2 = @prompt.yes?("Would you like a new random WOD?")
        if answer2 == true
          destroy_my_routine
          self.get_random_wod
        else
          puts "I will run self.run_wod"
        end
      end
    else
      @duration = @prompt.ask("How long would you like to workout today, in minutes? (MINIMUM 5 MINS, DONT BE LAZY!)")
      @user = User.create(name: @name, duration: @duration)
      puts "It's your first visit to WOD Gym, #{@name}, welcome!"
      get_random_wod
    end
  end

  def get_random_wod
    #when we run this, we have a user-defined duration stored in @duration.
    puts "Here is a random WOD of #{@duration} mins: \n"
    current_duration = 0
    until current_duration >= @duration.to_i
      selected = Exercise.all.sample
      if (current_duration += selected.duration) <= @duration.to_i
        Routine.create(user_id: @user.id, exercise_id: selected.id)
      else
        current_duration -= selected.duration
      end
    end
    User.find_by(name: @name).exercises.each_with_index do |o,i|
      puts "#{i+1}. #{o.name} (#{o.duration} mins) \n #{o.description}"
    end
    answer3 = @prompt.select("Would you like to proceed with this WOD or create your own WOD instead?", %w(Proceed Create))
    answer3 == "Proceed" ? (puts "I will run_wod") : select_wod
  end

  def destroy_my_routine
    Routine.where(user_id: @user.id).destroy_all
  end

  def select_wod
    destroy_my_routine
    hash = Hash.new
    Exercise.all.each do |o|
      key = "#{o.id}. #{o.name} (#{o.duration} mins) - #{o.description}"
      hash[key] = o.id
    end
    @my_wod = @prompt.multi_select("Please pick your exercises.", hash) #array of exercise.id
    @my_wod.each {|i| Routine.create(user_id: @user.id, exercise_id: i)}
    puts "Your WOD is the following:"
    User.find_by(name: @name).exercises.each_with_index do |o,i|
      puts "#{i+1}. #{o.name} (#{o.duration} mins) \n #{o.description}"
    end
    puts "LET'S GO!!!!!!!"
    # #stretch goals: display total mins of selected exercises
  end

  def make_custom_exercise
    puts "Have a signature move? Share it with other users!"
    e_name = @prompt.ask("What is your exercise name called?") do |q|
      q.required true
      # q.validate /\A\w+\Z/
    end
    e_description = @prompt.ask("Please enter a short description of #{e_name}:") do |q|
      q.required true
      # q.validate /\A\w+\Z/
    end
    e_duration = @prompt.ask("How many minutes will it take to complete this exercise?") do |q|
      q.required true
      # q.validate /^\d+$/
    end
    Exercise.create(name: e_name, description: e_description, duration: e_duration, user_id: @user.id)
    puts "Congratulations, #{e_name} is now on our exercise database!"
  end

  def view_my_custom_exercises
    puts "Here are the custom exercises you created. Thank you for the love <3: \n"
    Exercise.where(user_id: @user.id).each_with_index do |o,i|
      puts "#{i+1}. #{o.name} (#{o.duration} mins) \n #{o.description}"
    end
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
