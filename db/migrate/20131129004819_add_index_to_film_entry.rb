class AddIndexToFilmEntry < ActiveRecord::Migration
  def change
    add_index :film_entries, [:film_id, :user_id], :name => "index_film_entries_film_and_user"
  end
end
