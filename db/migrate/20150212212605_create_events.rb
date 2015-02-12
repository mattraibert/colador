class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :content
      t.integer :start_year
      t.integer :end_year
      t.point :location
      t.references :type, index: true
      t.string :source
      t.string :size
      t.boolean :published

      t.timestamps null: false
    end
    add_foreign_key :events, :types
  end
end
