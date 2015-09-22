class User < ActiveRecord::Base
  include Commentable
  attr_reader :password
  validates :username, :password_digest, :session_token, presence: true
  validates :username, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}
  after_initialize :ensure_session_token

  has_many :goals, dependent: :destroy

  # has_many :comments, as: :commentable

  has_many(
    :authored_comments,
    class_name: :Comment,
    primary_key: :id,
    foreign_key: :author_id
  )

  def self.find_by_credentials(username, password)
    user = User.find_by_username(username)
    return nil if user.nil? || !user.is_password?(password)
    user
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save!
    self.session_token
  end
end
