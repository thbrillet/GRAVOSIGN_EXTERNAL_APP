class AddJsonToPdf < ActiveRecord::Migration[5.2]
  def change
    add_column :pdfs, :json, :string
  end
end
