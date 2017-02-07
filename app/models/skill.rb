class Skill < ActiveRecord::Base
  belongs_to :skill_category
  has_many :user_skill_rates
  has_many :users, through: :user_skill_rates
  has_many :draft_skills
  has_one :requested_change, -> {
    where(draft_type: 'update', draft_status: 'created')
  }, anonymous_class: DraftSkill

  validates :name, :skill_category, :rate_type, :description, presence: true
  validates :ref_name, uniqueness: true, presence: true, unless: :skip_ref_name_validation
  validates :rate_type, inclusion: { in: ::Skills::RateType.stringified_types }

  attr_accessor :requester_explanation, :skip_ref_name_validation

  def set_ref_name!
    self.ref_name = "#{skill_category.name}_#{name}".parameterize
  end

  private

  def uniques
    return unless self.class.where(name: name, skill_category_id: skill_category_id).exists?
    errors.add('name & skill_category', 'must be uniq')
  end
end
