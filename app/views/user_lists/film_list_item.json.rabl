collection @film_list_items

node(:position) {|film_list_item| film_list_item.position}
node(:film) {|film_list_item| partial("films/summary", :object =>  FilmPresenter.new(current_user, Film.find(film_list_item.film_id), 'w45'))}

