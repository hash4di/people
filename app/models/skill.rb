class Skill < ActiveRecord::Base
  SF_API_NAME = 'Skill__c'.freeze

  before_destroy :delete_from_sf!

  belongs_to :skill_category
  has_many :user_skill_rates, dependent: :destroy
  has_many :draft_skills, -> { order(created_at: :asc) }, dependent: :destroy
  has_many :users, through: :user_skill_rates
  has_one :requested_change, -> {
    where(draft_type: 'update', draft_status: 'created')
  }, anonymous_class: DraftSkill
  has_one :requested_delete, -> {
    where(draft_type: 'delete', draft_status: 'created')
  }, anonymous_class: DraftSkill

  validates :name, :skill_category, :rate_type, :description, presence: true
  validates :ref_name, uniqueness: true, presence: true
  validates :rate_type, inclusion: { in: ::Skills::RateType.stringified_types }

  before_validation :set_ref_name!

  attr_accessor :requester_explanation

  private

  def uniques
    return unless self.class.where(name: name, skill_category_id: skill_category_id).exists?
    errors.add('name & skill_category', 'must be uniq')
  end

  def set_ref_name!
    unless skill_category
      errors[:ref_name] << 'Skill category and skill name have to be set.'
      return
    end
    self.ref_name = "#{skill_category.name}_#{name}".parameterize
  end

  def delete_from_sf!
    Salesforce::DestroyObjectService.new.call(api_name: SF_API_NAME, object: self)
  end
end
