class UserSkillRate < ActiveRecord::Base
  belongs_to :user
  belongs_to :skill

  validates :user, :skill, :rate, presence: true
  validates_with ::UserSkillRate::RateWithinRangeValidator
end
