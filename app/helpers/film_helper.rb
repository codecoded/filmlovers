module FilmHelper

  def title_with_year(film)
    "#{film.title} " << year(film)
  end

  def year(film)
    return "" unless film.year
    "(#{film.year})"
  end

  def tagline(film_view)
    film_view.tagline ? film_view.tagline :  "Overview"
  end

  def show_details(title, detail)
    return unless !detail.blank?
    detail = detail.kind_of?(Array) ? detail.join('<br/>').html_safe : detail
    content_tag(:h4, title) + content_tag(:p, detail)
  end

end
