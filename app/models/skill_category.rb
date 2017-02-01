class SkillCategory < ActiveRecord::Base
  has_many :skills
  has_many :roles

  validates :name, presence: true, uniqueness: true
end
