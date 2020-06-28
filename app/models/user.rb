# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  nickname               :string
#  phone                  :string
#  password_digest        :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i[github]
  has_one_attached :avatar
  has_many :tweets

  validates :email, uniqueness: true, :allow_blank => true
  validates :phone, uniqueness: true, :allow_blank => true

  def self.from_omniauth(auth)
    mock_password = Devise.friendly_token[0, 20]
    where(email: auth.info.email).first_or_create!(
        email: auth.info.email,
        nickname: auth.info.nickname,
        phone: "hahahahaha",
        password: mock_password)
        # password_confirmation: mock_password)
    # where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    #   user.provider = auth.provider
    #   user.uid = auth.uid
    #   user.email = auth.info.email
    #   user.password = Devise.friendly_token[0,20]
    # end
  end
end
