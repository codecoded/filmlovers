module FilmHelper

  def directed_by(film_view)
    return unless film_view.director
    content_tag :span,  "Directed by #{film_view.director}"
  end

  def year(film_view)
    return unless film_view.year
    content_tag :span, "(#{film_view.year})"
  end

  def tagline(film_view)
    film_view.tagline ? film_view.tagline :  "Overview"
  end

  def action_button(action, film)
    url = update_user_film_path(current_user, action, film.id)
    actioned = film.actioned?(action)
    method =  actioned ? :delete : :put
    button_tag type: :button, name: action, :class=> 'film-action', data: {href: url, method: method, remote: true } do 
      icon_for action, actioned
    end    
  end

  def icon_for(action, is_actioned)
    icons = {
      watched: 'icon-eye-open', 
      loved: 'icon-heart', 
      owned: 'icon-home', 
      queued: 'icon-pushpin'}

    action_css = is_actioned ? 'actioned' : 'unactioned'

    css = "#{icons[action]} #{action_css}"

    content_tag :i, nil,:class=> css
  end

  # def film_actioned_link(action, film, icon)
  #   content_tag :li do
  #     link_to update_user_film_path(current_user, action, film.id), method: :delete, remote: true do
  #         content_tag :i, nil, :class=>"#{icon} actioned"
  #     end
  #   end
  # end

  # def film_unactioned_link(action, film, icon)
  #   method = film.actioned?(action) ? :delete : :put 
  #   css_class = method? == :delete ? "actioned" : "unactiond"
  #   content_tag :li do
  #     link_to update_user_film_path(current_user, action, film.id), method: :put, remote: true do
  #         content_tag :i, nil, :class=>"#{icon} #{css_class} "
  #     end
  #   end
  # end

end
