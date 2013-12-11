class CreateFilmProviders < ActiveRecord::Migration
  def change
    create_table :film_providers do |t|
      t.references :film
      t.string :name
      t.string :provider_key
      t.string :link
      t.float :rating
      t.datetime :fetched_at

      t.timestamps
    end
    add_index :film_providers, :film_id
  end
end
