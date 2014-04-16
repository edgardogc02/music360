module UsersHelper

	def image_avatar(user)
		image_tag user.imagename_url, alt: user.username, class: "avatar"
	end
end
