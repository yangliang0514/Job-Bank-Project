class Resume < ApplicationRecord
  acts_as_paranoid

  # 用來作url slug的套件，可自動對resume產生slug，然後可以直接打slug在網址去取得
  extend FriendlyId
  friendly_id :name, use: %i[slugged finders]

  validates :name, presence: true
  validates :email,
            presence: true,
            format: {
              with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
            }
  validates :tel, presence: true

  belongs_to :user #會預設把這個欄位變成required(必填)，不要的話就要再加上option來關掉
  has_many :comments

  has_many :favorite_resumes
  has_many :users, through: :favorite_resumes

  def self.search(keyword)
    where("name LIKE ?", "%#{keyword}%")
  end
end
