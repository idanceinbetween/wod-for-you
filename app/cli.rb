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

  def confirm_duration
    if User.find_by(name: @name)
      @user = User.find_by(name: @name)
      puts "Welcome back #{@name}. Your last WOD was #{@user.exercises.sum(:length)} mins."
      answer1 = @prompt.yes?("Would you like to change the duration today?")#programme better if not y/n
      if answer1 == true
        duration = @prompt.ask("How long would you like to workout today, in minutes?")
        puts "Thanks, let me run a give_random_wod for you right now, hang on."
      else
        puts "Here is your WOD from the previous visit:"
        User.find_by(name: @name).exercises.each_with_index do |o,i|
          puts "#{i+1}. #{o.name} (#{o.length} mins) \n #{o.description}"
        end
        answer2 = @prompt.yes?("Would you like a new random WOD?")
        if answer2 == true
          puts "I will run self.give_random_wod"
        else puts "I will run self.run_wod"
        end
      end
    else
      @duration = @prompt.ask("How long would you like to workout today, in minutes?")
      @user = User.create(name: @name, duration: @duration)
      puts "It's your first visit to WOD Gym, #{@name}, welcome! I will run self.give_random_wod"
      puts User.find_by(name: @name)
    end
  end

  def give_random_wod

  end

  def start
    greet
    get_name
    confirm_duration
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
