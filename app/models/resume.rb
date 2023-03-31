class Resume < ApplicationRecord
  acts_as_paranoid

  validates :name, presence: true
  validates :email,
            presence: true,
            format: {
              with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
            }
  validates :tel, presence: true

  belongs_to :user

  def self.search(keyword)
    where("name LIKE ?", "%#{keyword}%")
  end
end
