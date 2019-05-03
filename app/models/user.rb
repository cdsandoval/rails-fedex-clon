class User < ApplicationRecord
  has_many :shipments
  has_many :providers

  validates :address, :city, :country, presence: true
  validates :username, presence: true
  EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: EMAIL_FORMAT }, uniqueness: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :omniauthable, omniauth_providers: %i[facebook github]

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.authentication_token = Devise.friendly_token[0, 30]
      user.username = auth.info.email.split("@")[0]
      user.country = "Peru"
      user.city = "Lima"
      user.address = "Calle Jorge Chavez 184"
    end
  end

  def invalidate_token
    update(token: nil)
  end

  def self.valid_login?(email, password)
    user = find_by(email: email)
    user if user&.valid_password?(password)
  end

  def regular?
    self.role == "regular"
  end

  def admin?
    self.role == "admin"
  end

  def sales?
    self.role == "sales"
  end

  def deposit?
    self.role == "deposit"
  end
  
end
