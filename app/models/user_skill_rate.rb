class UserSkillRate < ActiveRecord::Base
  SALESFORCE = {
    external_id: 'IDD__c',
    object: 'SkillRating__c'
  }.freeze

  scope :with_skills_and_users, -> { includes(:skills, :users) }
  scope :rated, -> { where('rate > 0') }

  belongs_to :user
  belongs_to :skill

  has_many :contents, class_name: '::UserSkillRate::Content', dependent: :destroy

  validates :user, :skill, presence: true
  validates :skill, uniqueness: { scope: :user }

  around_destroy :delete_from_sf!

  def content
    contents.order('user_skill_rate_contents.created_at asc').last
  end

  def delete_from_sf!
    Salesforce::DestroyObjectService.new.call('SkillRating__c', salesforce_id)
    yield
  end
end
