# == Schema Information
#
# Table name: labels
#
#  id           :integer          not null, primary key
#  name         :string
#  user_id      :integer
#  edunova_cert :boolean
#  media        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Label < ActiveRecord::Base
	belongs_to :user 
	validates_presence_of :name
end
