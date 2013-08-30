class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation
  before_create :create_remember_token
  before_save { self.email = email.downcase }
  before_save :password_save_after_validation

  validates :name, presence: true, length: { maximum: 50 }, on: :save
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, on: :save
  validates :password, length: { minimum: 6 }, on: :save
  validate :valid_password, on: :save

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

  def password_save_after_validation
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_digest = password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  end

  public
  def self.authenticate(email,password)
    puts "================================================================================================="
    puts email.inspect
    user = find_by_email(email)
    puts user.inspect
    salt = user.password_salt
    pass = BCrypt::Engine.hash_secret(password,salt)
    
    puts pass.inspect
    puts user.password_digest.inspect
    if user && user.password_digest == pass #BCrypt::Engine.hash_secret(password,user.password_salt)
      user
    else
      nil
    end
  end

end
