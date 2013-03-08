collection @film_list_items

#FilmPresenter.from_films(films_list.user, films_list.film_ids

node(:position) {|film_list_item| film_list_item.position}
node(:film) {|film_list_item| partial("films/summary", :object =>  FilmPresenter.new(film_list_item.films_list.user, Film.find(film_list_item.film_id), 'w45'))}

