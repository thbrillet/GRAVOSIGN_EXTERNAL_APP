class AddDetailsToPictures < ActiveRecord::Migration[5.2]
  def change
    add_column :pictures, :photo, :string
    remove_column :pictures, :url
  end
end
