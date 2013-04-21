collection @films_page


node(:header) do |films_page|
  {
    title: "Films Search",
    num: films_page.results_page.total_results,
    limit: 20
  }
end

node(:data) do |films_page|
  films_page.films.map do |film|
    {
      primary: film.title,
      secondary: release_date(film),
      image: (film.poster('w45') if film.has_poster?),
      onclick: "FL.Lists.addFilm(' #{list_view_film_path(film)}')"
    }
  end
end


