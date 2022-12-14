module ApplicationHelper

  def page_title
    if content_for?(:title)
      "#{content_for(:title)}".html_safe
    else
      "Learn to play guitar, learn to play piano, learn to play drums - InstrumentChamp"
    end
  end

  def set_page_title(text)
    content_for(:title){ text }
  end

  def page_meta_description
    if content_for?(:meta_description)
      (content_for(:meta_description).to_s).html_safe
    else
      "Learn to play guitar, learn to play piano, learn to play drums and more on InstrumentChamp"
    end
  end

  def set_meta_description(text)
    content_for(:meta_description){ text }
  end

	def nav_link(link_text, link_path, options={})
	  class_name = current_page?(link_path) ? 'active' : ''
    options.merge!({class: class_name +' list-group-item'})
    icon = options.delete(:icon)

    link_to link_path, options do
    	raw("<i class='glyphicon glyphicon-#{icon}'></i>") + link_text
    end
	end

	def body_classes(classes=nil)
    ary = []
    ary << controller.controller_name
    ary << controller.action_name
    ary << 'mobile' if mobile_agent?
    ary << 'no-signed-in' if !signed_in?

    unless classes.nil?
      method = classes.is_a?(Array) ? :concat : :<<
      ary.send method, classes
    end

    ary.join(' ')
  end

  def current_action?(controller="", action)
    if controller
      params[:controller] == controller
    else
      params[:action] == action
    end
  end

  def mobile_agent?
    return true if params[:mobile] == "1"
    request.user_agent =~ /Mobile|webOS/
  end

  def is_mobile?
    request.user_agent and /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.match(request.user_agent) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.match(request.user_agent[0..3])
  end

	def is_current_user?(user)
		current_user and current_user.id == user.id
	end

  def js_scripts
    if content_for?(:js_scripts)
      content_for(:js_scripts)
    end
  end

  def detail_header_thumb
    if content_for?(:detail_header_thumb)
      content_for(:detail_header_thumb)
    end
  end

  def detail_header_primary_info
    if content_for?(:detail_header_primary_info)
      content_for(:detail_header_primary_info)
    end
  end

  def detail_header_secondary_info
    if content_for?(:detail_header_secondary_info)
      content_for(:detail_header_secondary_info)
    end
  end

  def detail_header_nav_left
    if content_for?(:detail_header_nav_left)
      content_for(:detail_header_nav_left)
    end
  end

  def detail_header_nav_right
    if content_for?(:detail_header_nav_right)
      content_for(:detail_header_nav_right)
    end
  end

  def detail_right_col
    if content_for?(:detail_right_col)
      content_for(:detail_right_col)
    end
  end

  def facebook_og_meta
    if content_for?(:facebook_og_meta)
      content_for(:facebook_og_meta)
    end
  end

  def alert_class(flash_name)
    if flash_name.to_s == "notice"
      "alert-success"
    elsif flash_name.to_s == "warning"
      "alert-warning"
    else
      "alert-warning"
    end
  end

  def include_google_analytics?
    Rails.env.production? and !test_domain_name? and (!signed_in? or (signed_in? and !current_user.admin?))
  end

  def include_kissmetrics?
    Rails.env.production? and !test_domain_name?
  end

  def include_facebook_conversion_code?
    Rails.env.production? and !test_domain_name? and signed_in? and UserFacebookAccount.new(current_user).connected? and current_page?(home_path) and current_user.just_signup?
  end

  def skip_tour_link
    if redirect_to_new_challenge?
      new_challenge_path
    else
      home_path
    end
  end

  def tour_songs
    Song.featured.limit(4)
  end

  def action_button(url, text, options={}, icon=false)
    extra_class = ' btn btn-sm btn-primary action_button'
    if options[:class]
      options[:class] << extra_class
    else
      options[:class] = extra_class
    end
    link_to url, options do
      if icon
        content_tag(:i, '', class: icon) + content_tag(:span, text)
      else
        content_tag(:span, text)
      end
    end
  end

  def number_to_euro(amount)
    number_to_currency(amount, unit: '???', format: '%n %u')
  end

  def refresh_button(css_classes="" )
    link_to url_for(params), {class: "btn btn-primary #{css_classes}"} do
      content_tag :span, {class: "glyphicon glyphicon-refresh"} do
        content_tag :span, "Refresh", {class: "refresh-text"}
      end
    end
  end

end
