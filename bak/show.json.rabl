object @film

attributes :id, :title, :overview, :release_date, :trailer, :director, :year

node(:url) {|film| film_path(film.film.id)}
node(:thumbnail) {|film| film.thumbnail('w185')}

node :backdrops do |film_view|
    film_view.backdrops.map do |backdrop|
      AppConfig.image_uri_for(['w1280', backdrop['file_path']])
    end
end

node :genres do |film_view|
    film_view.film.genres.map do |genre|
    {
      name: genre['name'],
      url: films_genre_path(genre['name'].downcase.parameterize.underscore)
    }
    end
end

node :credits do |film_view|
{
  cast: film_view.film.credits.cast.map {|c| 
    {
      name: c['name'],
      character: c['character'],
      profile_picture: c['profile_path'] ? AppConfig.image_uri_for(['w90', c['profile_path']]) : '',
      url: person_path(c['_id']) 
    }
  },
  crew: film_view.film.credits.crew.map {|c| 
    {
      name: c['name'],
      department: c['department'],
      job: c['job'],
      profile_picture: c['profile_path'] ? AppConfig.image_uri_for(['w90', c['profile_path']]) : '' ,
      url: person_path(c['_id']) 
    }
  }
}
end


node :similar_films do |film_view|
{
  page: film_view.film.similar_movies['page'],
  total_pages: film_view.film.similar_movies['total_pages'],
  total_results: film_view.film.similar_movies['total_results'],
  films: film_view.film.similar_movies['results'].compact.map do |sim_film|
    {
      id: sim_film['id'],
      title: sim_film['title'], 
      poster_image: sim_film['poster_path'] ? AppConfig.image_uri_for(['w185', sim_film['poster_path']]) : 'http://placehold.it/185x237&text=no%20poster%20found',
      url: film_path(sim_film['id'])
    }
   end
}
end

node :stats do |film_view|
  {
    :watched => film_view.stats(:watched),
    :loved => film_view.stats(:loved),
    :owned => film_view.stats(:owned)
  }
end

if current_user
  node(:actions) do |film_view|
    [:watched, :loved, :owned, :queued].map do |action|
      {
        name: action,
        url: update_user_film_path(current_user, action, film_view.id),
        isActioned: film_view.actioned?(action),
        count: 0
      }
    end
  end
end

