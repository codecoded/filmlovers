module CinemasHelper

  def address
    cinema.address.values.join('</br>').html_safe
  end

  def title_with_rating(show)
    show.rating ? "#{show.title} (#{show.rating})" : "#{show.title}"
  end
end
