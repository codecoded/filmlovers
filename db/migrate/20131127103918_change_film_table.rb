class ChangeFilmTable < ActiveRecord::Migration
  def change
    create_table :films, id: false do |t|
      t.string :id
      t.string :title
      t.string :classification
      t.string :director
      t.date :release_date
      t.string :release_date_country
      t.datetime :fetched_at
      t.string :poster
      t.string :backdrop
      t.string :trailer
      t.string_array :genres
      t.float :popularity
      t.integer :provider_id
      t.string :provider
      t.string :title_director

      t.integer :watched_counter, default: 0, null: false
      t.integer :loved_counter,   default: 0, null: false
      t.integer :owned_counter,   default: 0, null: false

      t.timestamps
    end

    add_index :films, :id, unique: true
    # execute "ALTER TABLE films ADD PRIMARY KEY (id);"
  end
end
