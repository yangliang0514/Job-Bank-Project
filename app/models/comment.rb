class Comment < ApplicationRecord
  acts_as_paranoid

  # validation
  validates :content, presence: true

  # relationships
  belongs_to :user
  belongs_to :resume
end
