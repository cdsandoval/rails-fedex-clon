class User < ApplicationRecord
  has_many :shipments
  has_many :providers

  validates :address, :city, :country, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :omniauthable, omniauth_providers: %i[facebook github]



  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.email.split("@")[0]
      user.country = "Peru"
      user.city = "Lima"
      user.address = "Calle Jorge Chavez 184"
    end
  end

end
