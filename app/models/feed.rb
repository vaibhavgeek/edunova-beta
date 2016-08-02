# == Schema Information
#
# Table name: feeds
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  object_id  :integer
#  type       :string
#  fcontent   :string
#  comment_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Feed < ActiveRecord::Base
	belongs_to :user 
end
