class CreateCountryCodes < ActiveRecord::Migration
  def change
    create_table :country_codes do |t|
      t.string :name
      t.string :iso_name
      t.string :iso2
      t.string :iso3
      t.string :numcode
    end
  end
end
