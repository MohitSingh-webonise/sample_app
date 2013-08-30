class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation
  before_create :create_remember_token
  before_save { self.email = email.downcase }
  before_save :password_digest1

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validate :valid_password

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

  def valid_password
    if password.blank? || password_confirmation.blank?
      errors.add(:password, 'password must not be blank.')
    end

    if password != password_confirmation
      errors.add(:password, 'password and confirmation does not match.')
    end
  end

  public
  def password_digest1
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_digest = password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  end

  def self.authenticate(email,password)
    user = find_by_email(email)
    puts "================================================="
    puts user.inspect
    puts email.inspect
    puts password.inspect
    if user && user.password_digest == BCrypt::Engine.hash_secret(password,user.password_salt)
      user
    else
      nil
    end
  end

end
