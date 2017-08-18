class UserSkillRate < ActiveRecord::Base
  SALESFORCE = {
    external_id: 'IDD__c',
    object: 'SkillRating__c'
  }.freeze

  scope :with_skills_and_users, -> { includes(:skills, :users) }

  belongs_to :user
  belongs_to :skill

  has_many :contents, class_name: '::UserSkillRate::Content', dependent: :destroy

  validates :user, :skill, presence: true
  validates :skill, uniqueness: { scope: :user }

  scope :rated, -> { where('rate > 0') }

  def content
    contents.order('user_skill_rate_contents.created_at asc').last
  end
end
