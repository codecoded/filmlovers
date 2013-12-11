class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.string :avatar
      t.string :cover_image
      t.references :user

      t.timestamps
    end
    add_index :user_profiles, :user_id
  end
end
