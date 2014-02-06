module ApplicationHelper

	def nav_link(link_text, link_path, options)
	  class_name = current_page?(link_path) ? 'current' : ''

	  content_tag(:li, class: class_name) do
	    link_to link_path do
	    	raw("<i class='icon-#{options[:icon]}'></i>") + link_text
	    end
	  end
	end

end
