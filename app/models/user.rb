class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  # additing the following line as per 8.5.1
  # attr_accessible :name, :email, :password, :password_confirmation
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  has_secure_password
  before_save { email.downcase! }
  # alternative to the above two lines
  # before_save { self.email = email.downcase }
  
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  
  def User.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end
  
  private
  
    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
end
