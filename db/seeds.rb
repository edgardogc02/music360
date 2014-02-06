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
levels = [:greenhorn, :rookie, :player, :band_member, :instrumentchamp]

# Create a user account for each avatar image
Dir.foreach(Rails.root.join("vendor/assets/images/avatars")) do |avatar|
	next if avatar == "." or avatar == ".." or avatar == "johan.jpg"
	name = @generator.name(:all, false).downcase

	users << { 
		username: name, 
		avatar: avatar,
		email: "#{name}@gmail.com",
		level: levels.sample
	}
end

users << {
	username: "johan", 
	avatar: "johan.jpg",
	email: "johan.jvb@gmail.com",
	level: levels.sample
}

puts users

User.create(users)
