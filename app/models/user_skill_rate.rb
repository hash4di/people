class UserSkillRate < ActiveRecord::Base
  SALESFORCE = {
    external_id: 'IDD__c',
    object: 'SkillRating__c'
  }.freeze

  scope :with_skills_and_users, -> { includes(:skills, :users) }
  scope :rated, -> { where('rate > 0') }

  belongs_to :user
  belongs_to :skill

  before_destroy :delete_from_sf!

  has_many :contents, class_name: '::UserSkillRate::Content', dependent: :destroy

  validates :user, :skill, presence: true
  validates :skill, uniqueness: { scope: :user }

  def content
    contents.order('user_skill_rate_contents.created_at asc').last
  end

  private

  def delete_from_sf!
    Salesforce::DestroyObjectService.new.call(
      api_name: SALESFORCE[:object],
      object: self
    )
  end
end
