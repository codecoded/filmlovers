object @films_queue

return {} unless @films_queue
attributes :id, :title, :release_date

node(:url) {|film| film_path(film.film.id)}
node(:thumbnail) {|film| film.thumbnail('w90')}

node :stats do |film|
  {
    :watched => film.stats(:watched),
    :loved => film.stats(:loved),
    :owned => film.stats(:owned)
  }
end

if current_user
  node(:actions) do |film|
    [:watched, :loved, :owned, :queued].map do |action|
      {
        name: action,
        url: update_user_film_path(current_user, action, film.id),
        isActioned: film.actioned?(action),
        count: 0
      }
    end
  end
end

