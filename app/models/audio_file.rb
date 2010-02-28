class AudioFile < ActiveRecord::Base
  has_attached_file :audio
  belongs_to :user
  validates_attachment_presence :audio
end
