module ApplicationHelper

	def nav_link(link_text, link_path, options)
	  class_name = current_page?(link_path) ? 'active' : ''

	    link_to link_path, {class: class_name +' list-group-item' } do
	    	raw("<i class='glyphicon glyphicon-#{options[:icon]}'></i>") + link_text
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

  def js_scripts
    if content_for?(:js_scripts)
      content_for(:js_scripts)
    end
  end

  def facebook_og_meta
    if content_for?(:facebook_og_meta)
      content_for(:facebook_og_meta)
    end
  end

end
