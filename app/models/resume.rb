class Resume < ApplicationRecord
  acts_as_paranoid

  validates :name, presence: true
  validates :email,
            presence: true,
            format: {
              with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
            }
  validates :tel, presence: true

  belongs_to :user #會預設把這個欄位變成required(必填)，不要的話就要再加上option來關掉
  has_many :comments

  def self.search(keyword)
    where("name LIKE ?", "%#{keyword}%")
  end
end
