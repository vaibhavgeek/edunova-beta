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
   devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable , :omniauthable, :confirmable, :omniauth_providers => [:facebook ,:google_oauth2 ]


  
def self.from_omniauth(auth)
  where(email: auth.info.email).first_or_create do |user|
       uname = auth.info.name.downcase.parameterize
      max_slug = User.where("username like '#{uname}-%'")
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.name = auth.info.name
    user.skip_confirmation! 
    user.username = auth.uid.to_s
    if max_slug == nil
              max_count = 1
    else
            max_count = (max_slug.count.to_i + 1).to_s 
     end
            user.username =  "#{uname}-#{max_count}"
       end
 end


def self.from_omniauthg(access_token)
    data = access_token.info
    uname = access_token.info.first_name.downcase.parameterize
    max_slug = User.where("username like '#{uname}-%'")

    user = User.where(:email => data["email"]).first_or_create do |user|
                user.name = data["name"]
            user.gender = access_token.extra.raw_info.gender.to_s
            user.dob = access_token.extra.raw_info.birthday 
            user.skip_confirmation! 
            user.provider = access_token.provider.to_s 
            user.password = Devise.friendly_token[0,20] 
            if max_slug == nil
              max_count = 1
            else
            max_count = (max_slug.count.to_i + 1).to_s 
            end
            user.username =  "#{uname}-#{max_count}"
      end
end



end
