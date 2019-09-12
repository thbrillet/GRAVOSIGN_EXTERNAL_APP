class AddFilenameToPictures < ActiveRecord::Migration[5.2]
  def change
    add_column :pictures, :filename, :string
  end
end
