class SkillCategory < ActiveRecord::Base
  has_many :skills
  has_and_belongs_to_many :roles

  validates :name, presence: true, uniqueness: true
end
