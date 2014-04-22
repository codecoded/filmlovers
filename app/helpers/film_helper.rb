module FilmHelper

  # def tagline(film)
  #   film.details.tagline ? film.details.tagline :  "Overview"
  # end

  def show_details(title, detail, itemprop = nil)
    return unless !detail.blank?
    detail = detail.kind_of?(Array) ? detail.join('<br/>').html_safe : detail
    itemprop = {itemprop: itemprop} if itemprop
    content_tag(:h4, title) + content_tag(:p, detail.html_safe, itemprop)
  end

  # def film_entry_action(film_entry, action, text, is_counter = false)
    
  #   actioned = current_user ? film_entry.set?(action) : false

  #   action_css = actioned ? 'complete' : nil 
  #   url = current_user ? film_action_path(film, action) : '#'
  #   method =  actioned ? :delete : :put
  #   css = "#{action} #{action_css}"  
  #   content_tag :li, :class => css  do
  #     if is_counter
  #       link_to text, url, data: {'method-type'=> method, "film-action"=>  action,  id: film.id, counter: "#{film.id}_#{action}" }
  #     else
  #       link_to text, url, data: {'method-type'=> method, "film-action"=> action,  id: film.id }
  #     end
  #   end
  # end


end
