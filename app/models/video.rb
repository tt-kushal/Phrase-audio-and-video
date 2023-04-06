class Video < ApplicationRecord
  validates :url, presence: true
end