module UsersHelper

	def image_avatar(user)
		image_tag "avatars/#{user.avatar}", alt: user.username, class: "avatar"
	end
end
