module FilmsHelper

  def film_action_link(action, film, icon)
    method = film.actioned?(action) ? :delete : :put 
    css_class = method == :delete ? "actioned" : "unactiond"
    content_tag :div, :class=>"tiled left" do
      link_to update_user_film_path(current_user, action, film.id), method: method, remote: true do
          content_tag :i, nil, :class=>"#{icon} #{css_class}"
      end
    end
  end

end
