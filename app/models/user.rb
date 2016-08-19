# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  provider               :string
#  uid                    :string
#  image_id               :string
#  name                   :string
#  gender                 :string
#  intrested_in           :string
#  description            :string
#  username               :string           default(""), not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  slug                   :string
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_name                  (name)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  extend FriendlyId
  friendly_id :username,  use: [:slugged, :finders] 
  validates :username, format: { with: /\A[a-z0-9\-_]+\z/i  }
  has_attached_file :avatar, styles: { medium: "170x120>", thumb: "100x100>" }, default_url: "/assets/deafult-pic-130.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates_presence_of :username
  validates_uniqueness_of :username
  has_many :intrests
  has_many :notes
  has_many :comments
  has_many :lists
  has_many :relationships, :class_name => "Relationship"
  has_many :feeds
  has_many  :plays
  has_many :notifications , :class_name => "Notification"
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable , :omniauthable, :confirmable, :omniauth_providers => [:facebook ,:google_oauth2 ]

  before_create :slug_user
  after_create :after_signup_action
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  acts_as_taggable_on :interests


 
  def should_generate_new_friendly_id?
  if !slug? || username_changed? || new_record? || slug.nil? || slug.blank?
      true
    else
      false
    end
  end



def after_signup_action
  rel = Relationship.new(:following_id => self.id , :follower_id => self.id)
  rel.save
end

def slug_user

end


def self.from_omniauth(auth)
  where(email: auth.info.email).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.name = auth.info.name
    uname = user.name.parameterize 
    max_slug = User.where("username like '#{uname}-%'")
    if max_slug == nil
      max_count = 1
    else
      max_count = (max_slug.count.to_i + 1).to_s   
    end
    user.username =  "#{uname}-#{max_count}"        
    user.skip_confirmation! 
    end
end
 


def self.from_omniauthg(access_token)
    data = access_token.info
    where(:email => data["email"]).first_or_create do |user|
            user.name = data["name"]
            uname = user.name.parameterize 
            max_slug = User.where("username like '#{uname}-%'")
            if max_slug == nil
              max_count = 1
            else
              max_count = (max_slug.count.to_i + 1).to_s   
            end
            user.username =  "#{uname}-#{max_count}"
            user.gender = access_token.extra.raw_info.gender.to_s
            user.skip_confirmation! 
            user.provider = access_token.provider.to_s 
            user.password = Devise.friendly_token[0,20] 
    end
end



end
