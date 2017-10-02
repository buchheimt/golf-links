# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(
  username: "tylerB",
  email: "tyler@gmail.com",
  password: "123456",
  password_confirmation: "123456"
)

Course.create(
  name: "Augusta National GC",
  description: "Home of the Masters",
  location: "Augusta, GA"
)

Course.create(
  name: "Oakmont Country Club",
  description: "The oldest top-ranked golf course in the U.S.",
  location: "Pittsburgh, PA"
)

Course.create(
  name: "Innisbrook Resort (Copperhead)",
  description: "Home of the Valspar Championship",
  location: "Palm Harbor, FL"
)

Course.create(
  name: "Bay Hill Club & Lodge",
  description: "Home of the Arnold Palmer Invitational",
  location: "Orlando, FL"
)

TeeTime.create(course_id: Course.first.id, time: Time.now)
UserTeeTime.create(user_id: User.first.id, tee_time_id: TeeTime.first.id)
