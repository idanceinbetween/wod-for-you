User.destroy_all
Exercise.destroy_all

User.create([
    {name: "Admin", duration: 30},
    {name: "George", duration: 29},
    {name: "Alexa", duration: 15},
    {name: "Foo", duration: 10},
    {name: "Barry", duration: 4},
    {name: "Captain Marvel", duration: 5}
])
Exercise.create([
    {name: "Be a Drogon", description: "Breathe in fire. Breathe out fire.", duration: 1, user_id: 1},
    {name: "Pry", description: "Stand and sigh", duration: 1, user_id: 1},
    {name: "Git Push", description: "Get pushing in your pushups.", duration: 3, user_id: 1},
    {name: "One Handed Pry Pull Ups", description: "Debug code while doing one handed pullups", duration: 5, user_id: 1},
    {name: "Pull Hash", description: "Do pullups while iterating through a hash", duration: 10, user_id: 1},
    {name: "Pry Duck", description: "Throw your coding duck at your partner", duration: 5, user_id: 1},
    {name: "Be Array.each_with_index", description: "Line up and index your coding ducks", duration: 15, user_id: 1},
    {name: "Ruby Run", description: "Keep running until a crash", duration: 6, user_id: 1},
    {name: "Bubble Sort", description: "Look to the left and swap places if you are taller than the gym-er next to you", duration: 10, user_id: 1},
    {name: "While Loop", description: "Keep running forever", duration: 6, user_id: 1},
    {name: "Git Lucky", description: "Do a celebration dance", duration: 4, user_id: 1}
])

Routine.create([
  {user_id: 2, exercise_id: 1},
  {user_id: 2, exercise_id: 2},
  {user_id: 2, exercise_id: 3},
  {user_id: 3, exercise_id: 4},
  {user_id: 4, exercise_id: 5},
  {user_id: 5, exercise_id: 5}
  ])
