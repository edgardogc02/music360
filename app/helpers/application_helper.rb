module ApplicationHelper

	def nav_link(link_text, link_path, options)
	  class_name = current_page?(link_path) ? 'current' : ''

	  content_tag(:li, class: class_name) do
	    link_to link_path do
	    	raw("<i class='icon-#{options[:icon]}'></i>") + link_text
	    end
	  end
	end

	def body_classes(classes=nil)
	    ary = []
	    ary << controller.controller_name
	    ary << controller.action_name
	    ary << 'mobile' if mobile_agent?

	    unless classes.nil?
	      method = classes.is_a?(Array) ? :concat : :<<
	      ary.send method, classes
	    end

	    ary.join(' ')
	  end

	  def mobile_agent?
	    return true if params[:mobile] == "1"
	    request.user_agent =~ /Mobile|webOS/
	  end

		def is_current_user?(user)
			current_user and current_user.id == user.id
		end
end
