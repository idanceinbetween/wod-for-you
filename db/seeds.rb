User.destroy_all
Exercise.destroy_all

User.create([
    {name: "user1", duration: 30},
    {name: "user2", duration: 15},
    {name: "user3", duration: 10},
    {name: "user4", duration: 5},
    {name: "user5", duration: 3}
])
Exercise.create([
    {name: "Turn up the heat", description: "Warm up with deep breathing exercises with fire, ", duration: 2},
    {name: "Git Push Pry", description: "Keep doing pushups until you PRY", duration: 3},
    {name: "One Handed Pry Push Ups", description: "Debug code while doing one handed pushups", duration: 2},
    {name: "Pull Hash", description: "Do Pullups while iterating through a hash", duration: 10},
    {name: "Pry Duck", description: "Throw your coding duck at your partner", duration: 5},
])

Routine.create([
  {user_id: 1, exercise_id: 1},
  {user_id: 1, exercise_id: 2},
  {user_id: 1, exercise_id: 3},
  {user_id: 2, exercise_id: 4},
  {user_id: 2, exercise_id: 5},
  {user_id: 3, exercise_id: 5}
  ])
