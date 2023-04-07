class FavoriteResume < ApplicationRecord
  belongs_to :user
  belongs_to :resume
end
