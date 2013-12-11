class AddIndexToFilms < ActiveRecord::Migration
  def change
    add_index :films, [:title], :name => "index_films_title"
    add_index :films, [:release_date], :name => "index_films_release_date"
    add_index :films, [:watched_counter, :loved_counter, :owned_counter], :name => "index_films_counters"
  end
end
