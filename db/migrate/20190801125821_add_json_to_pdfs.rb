class AddJsonToPdfs < ActiveRecord::Migration[5.2]
  def change
    add_column :pdf, :json, :string
  end
end
