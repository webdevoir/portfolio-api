# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  name: "James Gallagher",
  email: "hello@jamesgallagher.io",
  password: "pass123456!",
  admin: true,
  profile_picture: "https://avatars2.githubusercontent.com/u/41574666?s=400&v=4",
  confirmed: true,
  confirm_token: "",
  bio: "React Web Developer, Startup Enthusiast"
)

User.create!(
  name: "Admin User",
  email: "admin@jamesgallagher.io",
  password: "pass123456!",
  admin: true,
  profile_picture: "https://github.com/jamesgallagher432/cdn/blob/master/misc/default_profile.jpeg?raw=true",
  confirmed: true,
  confirm_token: "",
  bio: "I am an Admin User."
)
