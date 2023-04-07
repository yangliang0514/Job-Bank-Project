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

  before_create :encrypt_password

  # relations 資料關聯，但是資料表本身其實沒關聯，只是幫你加了方法可以根據你的id去找resumes
  # 打user.resumes => Resume.where(user_id: id) 會這樣去找 (要注意單複數差別)，注意慣例，他會自己加上id
  # 不然就是要自己加class_name, foreign_key，這裡的resume就只是當這個model中的這個欄位名稱，只是如果跟class_name一樣就不用再指定
  has_many :resumes
  has_many :comments

  has_many :favorite_resumes
  has_many :liked_resumes, through: :favorite_resumes, source: :resume

  # enum，把數字的資料欄位顯示出來變成文字，注意是變成字串，不知道為啥
  enum role: { user: 1, company: 2, staff: 3 }

  def self.gender_list
    [["不公開", 0], ["男", 1], ["女", 2], ["其他", 3]]
  end

  def self.login(email:, password:) # 後面冒號一定要加，因為要取hash裡面的值，是Ruby的寫法，叫keyword argument
    encrypted_password = Digest::SHA1.hexdigest(password)
    User.find_by(email: email, password: encrypted_password)
  end

  def liked?(resume)
    # 去找那個user喜歡list中有沒有某個履歷
    self.liked_resumes.include?(resume)
  end

  private

  def encrypt_password
    # setter，這個有點難懂可能要再想想
    self.password = Digest::SHA1.hexdigest(self.password)
  end
end
