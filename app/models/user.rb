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

  before_save :encrypt_password

  def self.gender_list
    [["不公開", 0], ["男", 1], ["女", 2], ["其他", 3]]
  end

  def self.login(email:, password:) # 後面冒號一定要加，因為要取hash裡面的值，是Ruby的寫法，叫keyword argument
    encrypted_password = Digest::SHA1.hexdigest(password)
    User.find_by(email: email, password: encrypted_password)
  end

  private

  def encrypt_password
    # setter，這個有點難懂可能要再想想
    self.password = Digest::SHA1.hexdigest(self.password)
  end
end
