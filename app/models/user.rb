class User < ApplicationRecord
  validates :email,
            presence: true,
            uniqueness: true,
            confirmation: true,
            format: {
              with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
            }
  validates :password, presence: true
  validates :birthday, presence: true

  def self.gender_list
    [["不公開", 0], ["男", 1], ["女", 2], ["其他", 3]]
  end
end
