# User.destroy_all
# Exercise.destroy_all

User.create([
    {name: "user1", duration: 30, cardio?: true},
    {name: "user2", duration: 15, cardio?: true},
    {name: "user3", duration: 10, cardio?: true},
    {name: "user4", duration: 5, cardio?: false},
    {name: "user5", duration: 3, cardio?: false}
])
Exercise.create([
    {name: "Exercise 1"},
    {name: "Exercise 2"},
    {name: "Exercise 3"},
    {name: "Exercise 4"},
    {name: "Exercise 5"}
])

Routine.create([
  {user_id: 1, exercise_id: 1},
  {user_id: 1, exercise_id: 2},
  {user_id: 1, exercise_id: 3},
  {user_id: 2, exercise_id: 4},
  {user_id: 2, exercise_id: 5},
  {user_id: 3, exercise_id: 5}
  ])
