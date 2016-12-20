class UserSkillRate::Content < ActiveRecord::Base
  belongs_to :user_skill_rate

  validates :rate, presence: true
  validates_with ::UserSkillRate::RateWithinRangeValidator

  delegate :user_id, :skill_id, to: :user_skill_rate
end
