class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  #attr_accessor :password, :password_confirmation
  before_create :create_remember_token
  before_save { self.email = email.downcase }
  #before_save :password_save_after_validation
  has_secure_password

  validates :name, presence: true, length: { maximum: 50 }, on: :create
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, on: :create
  validates :password, length: { minimum: 6 }, on: :create
  #validate :valid_password, on: :create

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

  # def valid_password
  #   if password.blank? || password_confirmation.blank?
  #     errors.add(:password, 'password must not be blank.')
  #   end

  #   if password != password_confirmation
  #     errors.add(:password, 'password and confirmation does not match.')
  #   end
  # end

  # def password_save_after_validation
  #   self.password_salt = BCrypt::Engine.generate_salt
  #   self.password_digest = BCrypt::Engine.hash_secret(password, password_salt)
  # end

  public
  def self.authenticate(email,password)
    # puts "================================================================================================="
    # puts email.inspect
    user = find_by_email(email)
    # puts user.inspect
    # salt = user.password_salt
    # pass = BCrypt::Engine.hash_secret(password,salt)
    
    # puts pass.inspect
    # puts user.password_digest.inspect
    # if user && user.password_digest == pass #BCrypt::Engine.hash_secret(password,user.password_salt)
      if user && user.authenticate(password)
      # puts "Hello"
      # puts "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
      user
    else
      nil
    end
  end

end
