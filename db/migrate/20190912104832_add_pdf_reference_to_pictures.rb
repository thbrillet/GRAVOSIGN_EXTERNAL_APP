class AddPdfReferenceToPictures < ActiveRecord::Migration[5.2]
  def change
    add_reference :pictures, :pdf, foreign_key: true
  end
end
