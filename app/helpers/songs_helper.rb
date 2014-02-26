module SongsHelper

	def current_category(category) 
		current = params[:category]

		if (current == nil and category == nil) or
			(category != nil and current != nil and category.id == current.to_i)
			return "current"
		end
	end
end
