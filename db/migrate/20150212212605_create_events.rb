class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :content
      t.integer :start_year, null: false
      t.integer :end_year
      t.references :category, index: true, null: false
      t.references :location, index: true
      t.string :source
      t.string :size, null: false
      t.boolean :published, null: false

      t.timestamps null: false
    end
    add_foreign_key :events, :categories
  end
end
