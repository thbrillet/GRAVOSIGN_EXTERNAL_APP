class AddComparisonIdToPdf < ActiveRecord::Migration[5.2]
  def change
    add_column :pdfs, :comparison_id, :string
  end
end
