class CreatePassports < ActiveRecord::Migration
  def change
    create_table :passports do |t|
      t.string :provider
      t.string :uid
      t.string :oauth_token
      t.datetime :oauth_expires_at
      t.references :user

      t.timestamps
    end
    add_index :passports, :user_id
  end
end
