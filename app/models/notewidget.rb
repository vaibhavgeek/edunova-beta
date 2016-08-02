# == Schema Information
#
# Table name: notewidgets
#
#  id         :integer          not null, primary key
#  note_id    :integer
#  tag_one    :string
#  tag_two    :string
#  tag_three  :string
#  tag_four   :string
#  tag_five   :string
#  tag_six    :string
#  tag_seven  :string
#  tag_eight  :string
#  tag_nine   :string
#  tag_ten    :string
#  type       :string
#  certified  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Notewidget < ActiveRecord::Base
	belongs_to :user
	validates_prescence_of :note_id
end
