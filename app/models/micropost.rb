class Micropost < ActiveRecord::Base
  default_scope -> { order('created_at DESC') }
  attr_accessible :content, :user_id, :subject_id
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  has_many :micropost_subjects, :foreign_key => "micropost_id", :dependent => :destroy
  has_many :subjects, :through => :micropost_subjects

  belongs_to :user
  belongs_to :subject

  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                             WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
end
