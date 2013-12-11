class AddWatchedIndexToFilmEntry < ActiveRecord::Migration
  def change
    add_index :film_entries, [:user_id, :film_id]
    add_index :film_entries, [:watched, :loved, :owned]
  end
end
