module GroupsHelper

	def image_group(group)
	  if group.imagename
		  image_tag group.imagename, alt: group.name, class: "avatar"
		end
	end
end
