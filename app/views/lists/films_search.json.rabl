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
      secondary: film.release_date,
      image: film.thumbnail('w45'),
      onclick: "FL.Films.addListFilm(' #{list_films_path(list, id: film.film)}')"
    }
  end
end


