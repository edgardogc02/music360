module UsersHelper

	def image_avatar(user)
		image_tag user.avatar_url, alt: user.username, class: "avatar"
	end
end
