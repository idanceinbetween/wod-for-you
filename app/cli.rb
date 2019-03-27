require 'pry'
require 'TTY'

class CLI

  def initialize
   @prompt = TTY::Prompt.new
   @pastel = Pastel.new
   @font = TTY::Font.new(:doom)
 end

 def welcome
   puts @pastel.red(@font.write("                 WOD",letter_spacing: 4))
   puts "\n \n"
   puts @pastel.red.bold'               ᕙ( * •̀ ᗜ •́ * )ᕗ     ARE YOU READY TO GET MOVING MOVING?       ᕦ╏ ʘ̆ ‸ ʘ̆ ╏ᕤ'
   puts @pastel.red'               A coder & bored of your usual workout?'
   puts @pastel.red'               Workout of the Day app will:'
   puts @pastel.red'               * suggest a routine that suits your schedule'
   puts @pastel.red'               * discover exciting exercises for your body'
   puts @pastel.red'               * sharpen your mind for coding whilst you workout!'
   puts "\n \n"
 end

 def logo
   puts @pastel.red(@font.write("                 WOD",letter_spacing: 4))
   puts @pastel.blue"٩◔‿◔۶ Logged in as: #{@user.name}"
   puts "\n \n"
 end

 def reset
   system("clear")
 end

  def start
    reset
    welcome
    get_name
    set_up_user_and_greet
    main_menu
  end

  def get_name
    @name = @prompt.ask("What is your first name?") do |q|
        q.required true
    end
  end

  def set_up_user_and_greet
    if User.find_by(name: @name)
      @user = User.find_by(name: @name)
      @duration = @user.exercises.sum(:duration)
      puts @pastel.blue"Welcome back #{@name}. Have a great workout today!"
      spinner = TTY::Spinner.new("[:spinner] Loading ...", format: :pulse_2)
      spinner.auto_spin
      sleep(1)
      spinner.stop("Let's go!")
    else
      @user = User.create(name: @name, duration: 0)
      @duration = @user.exercises.sum(:duration)
      puts @pastel.blue"Looks like it's your first time here, #{@name}. Hope you enjoy our app!"
      spinner = TTY::Spinner.new("[:spinner] Loading ...", format: :pulse_2)
      spinner.auto_spin
      sleep(2)
      spinner.stop("Let's go!")
    end
  end

  def main_menu
    reset
    logo
    puts @pastel.blue.bold"Current Page: Main Menu"
    answer = @prompt.select("What would you like to do today?") do |menu|
      menu.choice "Workout now",1
      menu.choice "Browse exercises",2
      menu.choice "Find a nearby gym",3
      menu.choice "Delete my account",4
      menu.choice "Exit",5
      menu.choice "Change user",6
    end

    case answer
      when 1
        your_workout_menu
      when 2
        exercises_menu
      when 3
        find_gym
      when 4
        delete_account
      when 5
        exit
      when 6
        change_user
    end
  end

  def back_to_main_menu
    answer = @prompt.select("Back to Main Menu.") do |menu|
      menu.choice "Confirm", 1
    end
    answer.to_i == 1 ? main_menu : ""
  end

  def your_workout_menu
    reset
    logo
    puts @pastel.blue.bold"Current Page: --Workout Menu"
    answer = @prompt.select("Here are some things you could do now:") do |menu|
      menu.choice "Review your last WOD", 1
      menu.choice "Get new WOD", 2
      menu.choice "Create your own WOD", 3
      menu.choice "Back to Main Menu", 4
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

  def back_to_your_workout_menu
    answer = @prompt.select("Go back to previous menu.") do |menu|
      menu.choice "Confirm", 1
    end
    answer == 1 ? your_workout_menu : ""
  end

  def last_wod
    if @duration == 0
      puts @pastel.red("Looks like you don't have a previous WOD yet.")
      back_to_your_workout_menu
    else
      @prompt.say("Here is the WOD (#{@duration} mins) from your previous visit:", color: :blue)
      view_wod
    end
  end

  def view_wod
   reset
   logo
   puts "Reviewing Your WOD (#{@duration} mins)".center(200)
   puts ""
   puts "==============================================================".center(200)
   User.find_by(name: @name).exercises.each_with_index do |o,i|
     puts ""
     puts "#{i+1}. #{o.name} (#{o.duration} mins)".center(200)
     puts "#{o.description}".center(200)
     puts ""
     puts "==============================================================".center(200)
   end
   new_or_create_wod
end

  def new_wod
    if @duration == 0
      reset_duration
      get_random_wod
    else
      @prompt.say("Your last WOD was #{@duration} mins.")
      answer = @prompt.select("Would you like to change your workout duration today?") do |menu|
        menu.choice "Yes", 1
        menu.choice "No", 2
      end
      case answer
      when 1
        destroy_my_routine
        reset_duration
        get_random_wod
      when 2
        get_random_wod
      end
    end
  end

  def reset_duration
    @duration = @prompt.ask("How long would you like to workout today, in minutes? (MINIMUM 5 MINS, DONT BE LAZY!)")
    @prompt.say("Thanks, let me get a WOD for you right now.")
    @duration = @duration.to_i
  end

  def get_random_wod
    current_duration = 0
    until current_duration >= @duration
      selected = Exercise.all.sample
      if (current_duration += selected.duration) <= @duration
        Routine.create(user_id: @user.id, exercise_id: selected.id)
      else
        current_duration -= selected.duration
      end
    end
    view_wod
  end

  def new_or_create_wod
    answer = @prompt.select("What do you think?") do |menu|
      menu.choice "Great WOD, let's workout now!", 1
      menu.choice "Not sure about it, get a new WOD for me.", 2
      menu.choice "Don't like any of it! I'll create my own WOD.", 3
      menu.choice "Not feeling it now, take me back to the previous menu.", 4
    end

    case answer
      when 1
        confirm_wod_and_go
      when 2
        destroy_my_routine
        reset_duration
        get_random_wod
      when 3
        create_wod
      when 4
        your_workout_menu
      end
  end

  def confirm_wod_and_go
    answer = @prompt.select("Are you ready for this?") do |menu|
      menu.choice "Yes, let's do this!", 1
      menu.choice "Not really.", 2
    end
    case answer
    when 1
      @prompt.say("do run_wod")
      back_to_main_menu
    when 2
      @prompt.say("Fine, come back when you're ready!")
      back_to_exercises_menu
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
    @prompt.say("Your WOD is created and saved as the following:")
    view_wod
    confirm_wod_and_go
    # #stretch goals: display total mins of selected exercises
  end

  def exercises_menu
    reset
    logo
    puts @pastel.blue.bold"Current Page: --Exercises Menu"
    answer = @prompt.select("Here are some things you could do now:") do |menu|
      menu.enum '.'
      menu.choice "View the entire exercise database", 1
      menu.choice "Create your custom exercise!", 2
      menu.choice "View all custom exercises that you shared (you're the best!)", 3
      menu.choice "Edit/Delete your custom exercise!", 4
      menu.choice "Back to Main Menu", 5
    end

    case answer.to_i
      when 1
        view_all_exercises
      when 2
        create_custom_exercise
      when 3
        if my_custom_exercises.length ==0
          @prompt.error("You haven't created any custom exercises yet. Perhaps you would like to create one now?")
          back_to_exercises_menu
        else
          view_my_custom_exercises
        end
      when 4
        if my_custom_exercises.length ==0
          @prompt.error("You have no custom exercises to edit or delete. Please select another option.")
          back_to_exercises_menu
        else
          select_my_custom_exercise
        end
      when 5
        main_menu
    end
  end

  def back_to_exercises_menu
    answer = @prompt.select("Go back to previous menu.") do |menu|
      menu.choice "Confirm.", 1
    end
    answer == 1 ? exercises_menu : ""
  end

  def view_all_exercises
    reset
    logo
    puts "Reviewing Exercises Database".center(200)
    puts ""
    puts "==============================================================".center(200)
    Exercise.all.each_with_index do |o,i|
      puts ""
      puts "#{i+1}. #{o.name} (#{o.duration} mins)".center(200)
      puts "#{o.description}".center(200)
      puts ""
      puts "==============================================================".center(200)
    end
    back_to_exercises_menu
  end

  def create_custom_exercise
    @prompt.say("Have a signature move? Share it with other users!")
    e_name = @prompt.ask("What is your exercise name called?") do |q|
      q.required true
    end
    e_description = @prompt.ask("Please enter a short description of #{e_name}:") do |q|
      q.required true
    end
    e_duration = @prompt.ask("How many minutes will it take to complete this exercise?") do |q|
      q.required true
    end
    Exercise.create(name: e_name, description: e_description, duration: e_duration, user_id: @user.id)
    @prompt.say("ヽ(^◇^*)/ Excellent, #{e_name} is now on our exercise database!")
    back_to_exercises_menu
  end

  def my_custom_exercises
    @my_exercises = Exercise.where(user_id: @user.id)
  end

  def view_my_custom_exercises
    reset
    logo
    puts "Reviewing All Your Custom Exercises".center(200)
    puts ""
    puts "==============================================================".center(200)
    @my_exercises.each_with_index do |o,i|
      puts ""
      puts "#{i+1}. #{o.name} (#{o.duration} mins)".center(200)
      puts "#{o.description}".center(200)
      puts ""
      puts "==============================================================".center(200)
    end
    back_to_exercises_menu
  end

  def select_my_custom_exercise
    hash = Hash.new
    my_custom_exercises.all.each do |o|
      key = "#{o.id}. #{o.name} (#{o.duration} mins) - #{o.description}"
      hash[key] = o.id
    end

    @selected_custom_exercise_id = @prompt.select("Please select the custom exercise you want to edit/delete.", hash) #the exercise id
    @selected_custom_exercise = Exercise.find(@selected_custom_exercise_id)

    edit_or_delete_custom_exercise
  end

  def edit_or_delete_custom_exercise
    answer = @prompt.select("Would you like to edit or delete #{@selected_custom_exercise.name}?") do |menu|
      menu.enum '.'
      menu.choice "Edit", 1
      menu.choice "Delete", 2
    end

    case answer
      when 1
        edit_my_custom_exercise
        back_to_exercises_menu
      when 2
        delete_my_custom_exercise
        back_to_exercises_menu
    end
  end

  def edit_my_custom_exercise
    name = @prompt.ask("Please enter the updated name: (Currently: #{@selected_custom_exercise.name})")
    description = @prompt.ask("Please enter the updated description: (Currently: #{@selected_custom_exercise.description})")
    duration = @prompt.ask("Please enter the updated duration: (Currently: #{@selected_custom_exercise.duration})")
    Exercise.update(@selected_custom_exercise_id, name: name, description: description, duration: duration)
    @prompt.say("Fab! All updated as below:")
    @prompt.say("#{@selected_custom_exercise.name}")
    @prompt.say("#{@selected_custom_exercise.description}")
    @prompt.say("#{@selected_custom_exercise.duration}")
  end

  def delete_my_custom_exercise
    @selected_custom_exercise.destroy
    @prompt.say("The exercise has been deleted from the database.")
    back_to_exercises_menu
  end

  def delete_all_my_custom_exercises
    Exercise.where(user_id: @user.id).destroy_all
    @prompt.say("All your custom exercises have been deleted from the database.")
    back_to_exercises_menu
  end

  def delete_account
    @prompt.say("Oh no, what did we do? Did you get here by mistake?")
    answer = @prompt.select("What exactly are you looking for? \n It is not possible to delete your account but keep your custom exercises.") do |menu|
      menu.choice "Delete all my custom exercises only.", 1
      menu.choice "Delete my account, including all custom exercises I have created.", 2
      menu.choice "Forget about it, take me back to Main Menu."
    end

    case answer
    when 1
      delete_all_my_custom_exercises
      @prompt.say("All your custom exercises are deleted.")
      back_to_main_menu
    when 2
      delete_all_my_custom_exercises
      Routine.where(user_id: @user.id).destroy_all
      User.where(id: @user.id).destroy_all
      @prompt.say("Sad to see you go but hope you have a good life.")
      exit
    when 3
      @prompt.say("Glad you chose to stay! Sending you back to Main Menu...")
      back_to_main_menu
    end
  end

  def exit
    #image of a cake OR link to Dum Dum Doughnuts
    reset
  end

  def change_user
    start
  end

  def find_gym
    @postcode = @prompt.ask("What is your postcode?")
    Launchy.open("www.google.com/maps/search/?api=1&query=gyms+near #{@postcode}")
    back_to_main_menu
  end

  def music_suggest #Stretch goal
  end

  def share_wod #Stretch goal
  end

end
