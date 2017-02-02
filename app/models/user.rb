class User < ActiveRecord::Base

  VALID_EMAIL_REGEX =  /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  before_save { self.email = email.downcase }

  has_secure_password

  has_many :articles, dependent: :destroy

  validates :username, presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 25 }

  validates :email, presence: true,
            length: { maximum: 25 },
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }

end
