require 'namey'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

@generator = Namey::Generator.new

users = []
levels = ["Greenhorn", "Rookie", "Player", "Band member", "InstrumentChamp"]

# Create a user account for each avatar image
Dir.foreach(Rails.root.join("vendor/assets/images/avatars")) do |avatar|
	next if avatar == "." or avatar == ".." or avatar == "johan.jpg"
	name = @generator.name(:all, false).downcase

	users << { 
		username: name, 
		avatar: avatar,
		email: "#{name}@gmail.com",
		level: levels.sample,
		password: "password",
		password_confirmation: "password"
	}
end

users << {
	username: "johan", 
	avatar: "johan.jpg",
	email: "johan.jvb@gmail.com",
	level: levels.sample,
	password: "password",
	password_confirmation: "password"
}

puts "***** Seeding users ******"
User.create(users)

# CATEGORIES

puts "***** Seeding categories ******"
newRelases = Category.create(title: "New releases")
kids = Category.create(title: "Kids")
popular = Category.create(title: "Popular")

# ARTISTS

ledzep = Artist.create(title: "Led Zeppelin")
acdc = Artist.create(title: "AC/DC")
other = Artist.create(title: "Unknown")

# SONGS

songs = [
	{
		title: "Stairway To Heaven",
		category: popular,
		artist: ledzep
	},
	{
		title: "Highway To Hell",
		category: popular,
		artist: acdc
	},
	{
		title: "Lorem ipsum",
		category: kids,
		artist: other
	},
	{
		title: "Lorem ipsum",
		category: kids,
		artist: other
	},
	{
		title: "Lorem ipsum",
		category: popular,
		artist: other
	},
	{
		title: "Lorem ipsum",
		category: kids,
		artist: other
	},
	{
		title: "Lorem ipsum",
		category: kids,
		artist: other
	}
]

puts "***** Seeding songs ******"
Song.create(songs)
