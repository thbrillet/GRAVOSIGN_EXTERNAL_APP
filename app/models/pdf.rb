class Pdf < ApplicationRecord
  has_many :pictures, dependent: :destroy
end
