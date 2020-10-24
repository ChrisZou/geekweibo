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
  has_many :likes
  has_many :comments
  has_many :notifications, foreign_key: :recipient_id

  validates :email, uniqueness: true, allow_blank: true
  validates :phone, uniqueness: true, allow_blank: true

  def self.from_github_omniauth(auth)
    info = auth.info
    mock_password = Devise.friendly_token[0, 20]
    user = where(email: info.email).first_or_create!(email: info.email, nickname: info.nickname, phone: "", password: mock_password)
    # if !user.avatar.attached? && info.image && info.image.length > 0
    #   url = info.image
    #   user.avatar.attach(io: URI.open(url), filename: File.basename(URI.parse(url).path))
    #   user.save
    # end
    user
    # password_confirmation: mock_password)
    # where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    #   user.provider = auth.provider
    #   user.uid = auth.uid
    #   user.email = auth.info.email
    #   user.password = Devise.friendly_token[0,20]
    # end
  end

  def avatar_sized(size = 200)
    avatar.attached? && avatar.service_url(params: {"x-oss-process" => "image/resize,h_#{size},w_#{size}"})
  end

  def avatar_url
    return "" unless avatar.attached?
    avatar.service_url
  end

  def nickname
    super || "某个还没有设置昵称的用户"
  end
  def serializable_hash(options = {})
    h = super({only: public_infos}.merge(options))
    h[:avatar] = avatar_url
    h
  end

  private
  def public_infos
    [:id, :nickname]
  end

end
