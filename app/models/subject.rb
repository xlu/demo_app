class Subject < ActiveRecord::Base
  attr_accessible :birth_day, :birth_month, :birth_year, :name, :user_id, :birth_time
  validates :user_id, presence: true
  validates :birth_year, presence: true
  validates :birth_month, presence: true
  validates :birth_day, presence: true
  validates :birth_time, presence: true

  has_many :micropost_subjects, :foreign_key => "subject_id", :dependent => :destroy
  has_many :microposts, :through => :micropost_subjects

  belongs_to :user

  def has_birth_date?
    birth_month && birth_day && birth_year
  end

end
