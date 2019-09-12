class Picture < ApplicationRecord
  belongs_to :pdf

  mount_uploader :photo, PhotoUploader
end
