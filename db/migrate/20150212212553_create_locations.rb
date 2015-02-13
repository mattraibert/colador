class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :abbr
      t.integer :top
      t.integer :left
      t.string :name
      t.point :location

      t.timestamps null: false
    end
  end
end
