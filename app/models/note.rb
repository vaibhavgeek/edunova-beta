# == Schema Information
#
# Table name: notes
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :string
#  note_from_author :string
#  comments_id      :integer
#  spam             :boolean
#  labels           :string
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  slug             :string
#

class Note < ActiveRecord::Base

	belongs_to :user
	  validates_presence_of :name 
    acts_as_votable
  
      extend FriendlyId
    friendly_id :name,  use: [:slugged, :finders] 
   
   #Note_Widgets association
    has_many :notewidgets, :dependent => :destroy
    has_many :comments , :dependent => :destroy
  has_many :notifications , :dependent => :destroy 
  has_many :feeds ,  foreign_key: "object_id" , :dependent => :destroy
    accepts_nested_attributes_for :notewidgets, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  
  def self.search(search)
  	if search
    	t = Note.arel_table
    	Note.where(t[:name].matches("%#{search}%"))
  	else
    	where(nil)
  	end
  end
 
end
