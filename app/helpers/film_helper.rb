module FilmHelper

  # def tagline(film)
  #   film.details.tagline ? film.details.tagline :  "Overview"
  # end

  def show_details(title, detail)
    return unless !detail.blank?
    detail = detail.kind_of?(Array) ? detail.join('<br/>').html_safe : detail
    content_tag(:h4, title) + content_tag(:p, detail)
  end

end
