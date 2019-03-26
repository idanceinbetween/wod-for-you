require 'pry'
require 'TTY'

class CLI

  def initialize
   @prompt = TTY::Prompt.new
   @pastel = Pastel.new
   @font = TTY::Font.new(:doom)
 end

 def greet
   puts @pastel.red(@font.write("         WOD",letter_spacing: 4))
   puts @pastel.red.bold'                 ARE YOU READY TO GET THE BODY OF YOUR DREAMS?????????? YEAHHHHHHHH'
 end

  def start
    greet
    get_name
    set_up_user_and_greet
    main_menu
    # confirm_duration
    # create_custom_exercise
    # view_my_custom_exercises
  end

  def get_name
    @name = @prompt.ask("What is your first name?") do |q|
        q.required true
        q.validate /\A\w+\Z/
    end
  end

  def set_up_user_and_greet
    if User.find_by(name: @name)
      @user = User.find_by(name: @name)
      @duration = @user.exercises.sum(:duration)
      @prompt.say("Welcome back #{@name}!")
    else
      @user = User.create(name: @name, duration: 0)
      @duration = @user.exercises.sum(:duration)
      @prompt.say("Looks like it's your first time here, #{@name}. Hope you enjoy our app!")
    end
  end

  def main_menu
    answer = @prompt.select("What would you like to do today?") do |menu|
      menu.enum '.'
      menu.choice "Workout now!",1
      menu.choice "Browse exercises (including your custom ones!)",2
      menu.choice "Find Gym - PAY FOR THIS FEATURE MATE",3
      menu.choice "Delete Account (Nooooooooooo...)",4
      menu.choice "CAN'T DEAL WITH THIS ANYMORE. Time for cake. GOODBYE",5
    end

    case answer
      when 1
        workout_now_menu
      when 2
        browse_exercises_menu
      when 4
        delete_account
    end

  end

  def workout_now_menu
    answer = @prompt.select("Here are some things you could do now:") do |menu|
      menu.enum '.'
      menu.choice "View your last WOD", 1
      menu.choice "Get new WOD", 2
      menu.choice "Create your own WOD", 3
      menu.choice "Back to main menu", 4
    end

    case answer.to_i
    when 1
      last_wod
    when 2
      new_wod
    when 3
      create_wod
    when 4
      main_menu
    end
  end

  def last_wod
    if @duration == 0
      @prompt.error("Looks like you don't have a previous WOD yet. Please select Get new WOD or Create your own WOD from the menu.")
      workout_now_menu
    else
      @prompt.say("Here is your WOD (#{@duration} mins) from the previous visit:")
      display_wod
      workout_now_menu
    end
  end

  def display_wod
    User.find_by(name: @name).exercises.each_with_index do |o,i|
      puts "#{i+1}. #{o.name} (#{o.duration} mins) \n #{o.description}"
    end
  end

  def new_wod
    if @duration == 0
      reset_duration_and_get_random_wod
    else
      @prompt.say("Your last WOD was #{@duration} mins.")
      answer1 = @prompt.yes?("Would you like to change the duration today?")#programme better if not y/n
      if answer1
        destroy_my_routine
        reset_duration_and_get_random_wod
      else
        get_random_wod
      end
    end
  end

  def reset_duration_and_get_random_wod
    @duration = @prompt.ask("How long would you like to workout today, in minutes? (MINIMUM 5 MINS, DONT BE LAZY!)")
    @prompt.say("Thanks, let me get a WOD for you right now.")
    get_random_wod
  end

  def get_random_wod
    @prompt.say("Here is a WOD of #{@duration} mins: \n")
    current_duration = 0
    until current_duration >= @duration.to_i
      selected = Exercise.all.sample
      if (current_duration += selected.duration) <= @duration.to_i
        Routine.create(user_id: @user.id, exercise_id: selected.id)
      else
        current_duration -= selected.duration
      end
    end
    display_wod
    new_or_create_wod
  end

  def new_or_create_wod
    answer3 = @prompt.select("Would you like to proceed with this WOD or create your own WOD instead?", %w(Proceed Create))
    answer3 == "Proceed" ? confirm_wod_and_go : create_wod
  end

  def confirm_wod_and_go
    answer = @prompt.yes?("ARE YOU READY????")
    if answer
      puts "do run_wod"
    else
      puts "fine, let's go back to the menu and you make up your mind what you want to do!"
      workout_now_menu
    end
  end

  def destroy_my_routine
    Routine.where(user_id: @user.id).destroy_all
  end

  def create_wod
    destroy_my_routine

    hash = Hash.new
    Exercise.all.each do |o|
      key = "#{o.id}. #{o.name} (#{o.duration} mins) - #{o.description}"
      hash[key] = o.id
    end
    @my_wod = @prompt.multi_select("Please pick your exercises.", hash) #array of exercise.id
    @my_wod.each {|i| Routine.create(user_id: @user.id, exercise_id: i)}
    @prompt.say("Your WOD is the following:")
    display_wod
    confirm_wod_and_go
    # #stretch goals: display total mins of selected exercises
  end

  def browse_exercises_menu
    answer = @prompt.select("Here are some things you could do now:") do |menu|
      menu.enum '.'
      menu.choice "View the entire exercise database", 1
      menu.choice "View all custom exercises that you shared (you're the best!)", 2
      menu.choice "Create your exercise!", 3
      menu.choice "Back to main menu", 4
    end

    case answer.to_i
    when 1
      view_all_exercises
    when 2
      view_my_custom_exercises
    when 3
      create_custom_exercise
    when 4
      main_menu
    end
  end

  def view_all_exercises
    Exercise.all.each_with_index do |o,i|
      puts "#{i+1}. #{o.name} (#{o.duration} mins) \n #{o.description}"
    end
    browse_exercises_menu
  end

  def create_custom_exercise
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
    browse_exercises_menu
  end

  def my_custom_exercises
    @my_exercises = Exercise.where(user_id: @user.id)
  end

  def view_my_custom_exercises
    if my_custom_exercises.length < 0
      puts "You haven't created any custom exercises yet. Perhaps you would like to create one now?"
    else
      puts "Here are the custom exercises you created. Thank you for the love <3: \n"
      @my_exercises.each_with_index do |o,i|
        puts "#{i+1}. #{o.name} (#{o.duration} mins) \n #{o.description}"
      end
    end
    browse_exercises_menu
  end

  def select_my_custom_exercise
    hash = Hash.new
    my_custom_exercise.all.each do |o|
      key = "#{o.id}. #{o.name} (#{o.duration} mins) - #{o.description}"
      hash[key] = o.id
    end
  end

  def update_my_custom_exercise

  end

  def delete_my_custom_exercise

  end

  def delete_all_my_custom_exercises
    Exercise.where(user_id: @user.id).destroy_all
  end

  def delete_account
    @prompt.say("Oh no, what did we do? Why are you leaving us????")
    # binding.pry
    answer = @prompt.yes?("Are you sure you want to delete your account? It will also delete all custom exercises that you created.")
    if answer
      delete_all_my_custom_exercises
      Routine.where(user_id: @user.id).destroy_all
      User.where(id: @user.id).destroy_all
      puts "Sad to see you go. Hope you have a good life."
    else
      puts "YES. That's the right thing to do. Off you go - back to the main menu."
      main_menu
    end
  end

  def closest_gyms #Stretch goal
  end

  def music_suggest #Stretch goal
  end

  def share_wod #Stretch goal
  end

end
