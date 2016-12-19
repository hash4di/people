class UserSkillRate < ActiveRecord::Base
  belongs_to :user
  belongs_to :skill

  validates :user, :skill, presence: true
  validates :skill, uniqueness: { scope: :user }
  validates_with ::UserSkillRate::RateWithinRangeValidator
end
