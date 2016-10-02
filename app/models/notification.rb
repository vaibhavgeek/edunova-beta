# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  read       :integer
#  from_id    :integer
#  to_id      :integer
#  person3_id :integer
#  type       :string
#  content    :string
#  object_id  :integer
#  note_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  category   :string
#

class Notification < ActiveRecord::Base
	belongs_to :to_id , :class_name => "User" , :foreign_key => :to_id
	belongs_to :from_id , :class_name => "User" , :foreign_key => :from_id
	belongs_to :note
end
