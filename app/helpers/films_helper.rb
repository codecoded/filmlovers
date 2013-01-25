module FilmsHelper

  def film_action_link(action, film, icon)
    film.actioned?(action) ? film_actioned_link(action, film, icon) : film_unactioned_link(action, film, icon)
  end

  def film_actioned_link(action, film, icon)
    content_tag :li do
      link_to update_film_path(username, action, film.id), method: :delete, remote: true do
          content_tag :i, nil, :class=>"#{icon} actioned"
      end
    end
  end

  def film_unactioned_link(action, film, icon)
    method = film.actioned?(action) ? :delete : :put 
    content_tag :li do
      link_to update_film_path(username, action, film.id), method: :put, remote: true do
          content_tag :i, nil, :class=>"#{icon} unactioned"
      end
    end
  end

end
