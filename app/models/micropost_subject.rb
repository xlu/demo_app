class MicropostSubject < ActiveRecord::Base
  attr_accessible :micropost_id, :subject_id
  belongs_to :micropost, class_name: "Micropost"
  belongs_to :subject, class_name: "Subject"
  validates :micropost_id, presence: true
  validates :subject_id, presence: true
end
