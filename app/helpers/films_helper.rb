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

 def thumbnail(film, size='w154')
    size = size ? size : 'w154'
    src = film.has_poster? ? film.poster(size) : "http://placehold.it/#{size.slice(1..-1)}&text=no%20poster%20found"
    image_tag src, :title=>film.title, :class=>'small'
  end


end
