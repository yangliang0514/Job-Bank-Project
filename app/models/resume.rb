class Resume < ApplicationRecord
  validates :name, presence: true
  validates :email,
            presence: true,
            format: {
              with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
            }
  validates :tel, presence: true
end
