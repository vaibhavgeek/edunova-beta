# == Schema Information
#
# Table name: plays
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  note_id       :integer
#  current_level :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Play < ActiveRecord::Base
end
