class RenameTypeToCategory < ActiveRecord::Migration
  def change
    rename_table(:types, :categories)
    rename_column(:events, :type_id, :category_id)
  end
end
