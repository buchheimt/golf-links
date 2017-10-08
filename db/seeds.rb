# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

50.times {|i| User.create(
    username: "user#{i}",
    email: "user#{i}@gmail.com",
    password: "123456",
    password_confirmation: "123456",
    pace: rand(10) + 1,
    experience: rand(10) + 1
  )}

courses = [
  {name: "Augusta National GC", description: "Home of the Masters", location: "Augusta, GA"},
  {name: "Oakmont Country Club", description: "The oldest top-ranked golf course in the U.S.", location: "Pittsburgh, PA"},
  {name: "Innisbrook Resort (Copperhead)", description: "Home of the Valspar Championship", location: "Palm Harbor, FL"},
  {name: "Bay Hill Club & Lodge", description: "Home of the Arnold Palmer Invitational", location: "Orlando, FL"},
  {name: "Waialae CC", description: "Home of the Sony Open", location: "Honolulu, HI"},
  {name: "Torrey Pines GC (South)", description: "Home of the Farmers Insurance Open", location: "San Diego, CA"},
  {name: "Riviera CC", description: "Home of the Genesis Open", location: "Pacific Palisades, CA"},
  {name: "Harbour Town GL", description: "Home of the RBC Heritage", location: "Hilton Head, SC"},
  {name: "TPC San Antonio", description: "Home of the Valero Texas Open", location: "San Antonio, TX"},
  {name: "Quail Hollow Club", description: "Home of the Wells Fargo Championship", location: "Charlotte, NC"}
]

courses.each {|attributes| Course.create(attributes)}

100.times do
  course = Course.all[rand(Course.all.size)]
  year = rand(2) + 2017
  month = rand(12) + 1
  day = rand(30) + 1
  hour = rand(12) + 7
  time = DateTime.new(year, month, day, hour)
  tee_time = course.tee_times.build(time: time)
  (rand(4) + 1).times do
    user = User.all[rand(User.all.size)]
    tee_time.add_user(user)
  end
  course.save
end
