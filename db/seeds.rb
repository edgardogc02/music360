# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = []
levels = ["Greenhorn", "Rookie", "Player", "Band member", "InstrumentChamp"]
people_types = [
	PeopleCategory.create(title: "Teachers"),
	PeopleCategory.create(title: "Friends"),
	PeopleCategory.create(title: "Top players")]

30.times do |num|
	name = "johndoe_#{num}"

	users << {
		username: name,
		avatar_url: "http://placehold.it/300x300",
		email: "#{name}@gmail.com",
		level: levels.sample,
		people_category: people_types.sample,
		password: "password",
		password_confirmation: "password"
	}
end

johan = User.create({
	username: "johan",
	avatar_url: "http://placehold.it/300x300",
	email: "johan.jvb@gmail.com",
	level: levels.sample,
	password: "password",
	password_confirmation: "password"
})

puts "***** Seeding #{users.size} users ******"
User.create(users)

# CATEGORIES

puts "***** Seeding categories ******"
newRelases = Category.create(title: "New releases")
kids = Category.create(title: "Kids")
popular = Category.create(title: "Popular")

# ARTISTS

ledzep = Artist.create(title: "Led Zeppelin",
	bio: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Commodi, distinctio, ratione aut rem quae nam nostrum facere dicta qui rerum debitis nesciunt nobis dolor iste obcaecati ea pariatur eveniet sequi!",
	country: "USA")
acdc = Artist.create(title: "AC/DC",
	bio: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Commodi, distinctio, ratione aut rem quae nam nostrum facere dicta qui rerum debitis nesciunt nobis dolor iste obcaecati ea pariatur eveniet sequi!",
	country: "USA")
other = Artist.create(title: "Unknown")

# SONGS

songs = [
	{
		title: "Stairway To Heaven",
		category: popular,
		artist: ledzep,
		writer: "Lorem Ipsum",
		onclient: false,
		status: 1,
		length: 1,
		difficulty: 1,
		arranger_userid: 1,
		published_at: Time.now,
		cover: "http://upload.wikimedia.org/wikipedia/en/2/26/Led_Zeppelin_-_Led_Zeppelin_IV.jpg"
	},
	{
		title: "Highway To Hell",
		category: popular,
		artist: acdc,
		writer: "Lorem Ipsum",
		onclient: false,
		status: 1,
		length: 1,
		difficulty: 1,
		arranger_userid: 1,
		published_at: Time.now,
		cover: "http://ecx.images-amazon.com/images/I/31XXJ7KVAGL.jpg"
	},
	{
		title: "Kashmir",
		category: kids,
		artist: ledzep,
		writer: "Lorem Ipsum",
		onclient: false,
		status: 1,
		length: 1,
		difficulty: 1,
		arranger_userid: 1,
		published_at: Time.now,
		cover: "http://upload.wikimedia.org/wikipedia/en/e/e3/Led_Zeppelin_-_Physical_Graffiti.jpg"
	},
	{
		title: "Lorem ipsum",
		category: kids,
		artist: other,
		writer: "Lorem Ipsum",
		onclient: false,
		status: 1,
		length: 1,
		difficulty: 1,
		arranger_userid: 1,
		published_at: Time.now
	},
	{
		title: "Lorem ipsum",
		category: popular,
		artist: other,
		writer: "Lorem Ipsum",
		onclient: false,
		status: 1,
		length: 1,
		difficulty: 1,
		arranger_userid: 1,
		published_at: Time.now
	},
	{
		title: "Lorem ipsum",
		category: kids,
		artist: other,
		writer: "Lorem Ipsum",
		onclient: false,
		status: 1,
		length: 1,
		difficulty: 1,
		arranger_userid: 1,
		published_at: Time.now
	},
	{
		title: "Lorem ipsum",
		category: kids,
		artist: other,
		writer: "Lorem Ipsum",
		onclient: false,
		status: 1,
		length: 1,
		difficulty: 1,
		arranger_userid: 1,
		published_at: Time.now
	}
]

puts "***** Seeding songs ******"
Song.create!(songs)


# CHALLENGES

challenges = []

challenges << {
	challenger: johan,
	public: true,
	instrument: 'Guitar',
	song: Song.first,
	challenged: User.last
}

1.times do |num|
	challenges << {
		challenger: User.last,
		public: true,
		instrument: 'Guitar',
		song: Song.last,
		challenged: johan,
		created_at: num.days.ago
	}
end

puts "***** Seeding challenges ******"

Challenge.create!(challenges)
