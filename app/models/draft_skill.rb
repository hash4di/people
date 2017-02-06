class DraftSkill < ActiveRecord::Base
  belongs_to :skill
  belongs_to :skill_category
  belongs_to :requester, foreign_key: "requester_id", class_name: "User"
  belongs_to :reviewer, foreign_key: "reviewer_id", class_name: "User"

  STATUSES = %w(created accepted declined).freeze
  TYPES = %w(update create).freeze

  validates :draft_type, inclusion: { in: TYPES }
  validates :draft_status, inclusion: { in: STATUSES }

  def resolved?
    draft_status != 'created'
  end

  def accepted?
    draft_status == 'accepted'
  end

  def create_type?
    draft_type == 'create'
  end
end
