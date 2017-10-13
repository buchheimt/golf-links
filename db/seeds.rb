# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#https://uinames.com/api/?amount=50&maxlen=20&ext&region=united+states
require 'open-uri'

temp = open('https://uinames.com/api/?amount=50&maxlen=20&ext&region=united+states').read
hash = JSON.parse temp

hash.each do |user|
  User.create(
    username: "#{user["name"]}#{user["surname"][0].upcase}#{user["credit_card"]["pin"].to_s[0..2]}",
    email: user["email"],
    password: user["password"],
    pace: rand(10) + 1,
    experience: rand(10) + 1,
    image: user["photo"]
  )
end

courses = [
  {
    name: "Cowboys Golf Club",
    description: "Etched into the rolling hills of Grapevine, Texas, Cowboys Golf Club is distinguished as the first and only NFL-themed golf club in the world, and one of the region's only all-inclusive world-class resort golf properties.",
    location: "Grapevine, TX",
    par: 72,
    length: 7017,
    price: 140
  },
  {
    name: "Iron Horse Golf Course",
    description: "Iron Horse Golf Course's award-winning championship golf course serves as the centerpiece to a full-service daily fee golf facility boasting an array of dining and event amenities and numerous opportunities for fun and competitive play.",
    location: "North Richard Hills, TX",
    par: 70,
    length: 6700,
    price: 60
  },
  {
    name: "Tierra Verde Golf Club",
    description: "It's hard to find a more beautiful course than the award-winning Tierra Verde Golf Club. Tierra Verde is the first golf course in Texas and the first municipal course in the world to be certified as an Audubon Signature Sanctuary.",
    location: "Arlington, TX",
    par: 72,
    length: 6975,
    price: 72
  },
  {
    name: "Tangle Ridge Golf Club",
    description: "Tangle Ridge Golf Course in Grand Prairie, TX, will challenge your senses and skills. This 18-hole championship public golf course features exciting elevation changes, subtle Champion Ultra Dwarf Bermuda Grass Greens, tree-lined fairways, and water and sand hazards.",
    location: "Grand Prairie, TX",
    par: 72,
    length: 6835,
    price: 50
  },
  {
    name: "Tenison Park GC",
    description: "Tenison Highlands is one of the most popular golf courses in Texas. Redesigned in 2001 by PGA Tour professional D. A. Weibring and architect Steve Wolfard, the Highlands now has five beautiful lakes, 32 sand bunkers, tiff-eagle greens, and 419 Bermuda fairways to go along with its elevation changes and groves of hardwood trees.",
    location: "Dallas, TX",
    par: 72,
    length: 7078,
    price: 27
  },
  {
    name: "The Bridges Golf Club",
    description: "The Bridges Golf Club, a magnificent 18-hole Fred Couples Signature Golf Course, winds its way through The Bridges at Preston Crossings, a North Texas community, adding to the lush, park-like feel of the neighborhood.",
    location: "Gunter, TX",
    par: 72,
    length: 7612,
    price: 65
  },
  {
    name: "Texas Star Golf Course",
    description: "The Texas Star Golf Course and Conference Centre is conveniently located in Euless, Texas. It is a vibrant part of the Euless community.",
    location: "Euless, TX",
    par: 71,
    length: 6936,
    price: 77
  },
  {
    name: "The Tribute Golf Club",
    description: "Located in The Colony, Texas, just off the eastern shores of Lake Lewisville, The Tribute at The Colony offers a unique Scottish links-style golf experience unlike any other in North Texas, complemented by an array of upscale amenities – all open to the public.",
    location: "The Colony, TX",
    par: 72,
    length: 7002,
    price: 129
  },
]

courses.each {|attributes| Course.create(attributes)}

100.times do
  course = Course.all[rand(Course.all.size)]
  year = 2017
  month = rand(6) + 7
  day = rand(30) + 1
  hour = rand(12) + 7
  time = DateTime.new(year, month, day, hour)
  tee_time = course.tee_times.build(time: "Dec 30, 2099")
  (rand(4) + 1).times do
    user = User.all[rand(User.all.size)]
    tee_time.add_user(user)
  end
  tee_time.save
  tee_time.update(time: time)
  course.save
end
