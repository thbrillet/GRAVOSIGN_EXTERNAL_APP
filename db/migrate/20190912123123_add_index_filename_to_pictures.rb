class AddIndexFilenameToPictures < ActiveRecord::Migration[5.2]
  def change
    add_index :pictures, :filename
  end
end
