class AddCustomCssToEvents < ActiveRecord::Migration
  def change
    add_column :events, :custom_css, :string
  end
end
