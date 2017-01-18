class Skill < ActiveRecord::Base
  belongs_to :skill_category
  has_many :user_skill_rates
  has_many :users, through: :user_skill_rates

  validates :ref_name, :name, :skill_category, :rate_type, presence: true
  validates :ref_name, uniqueness: true
  validates :rate_type, inclusion: { in: ::Skills::RateType.stringified_types }
  validate :uniques, if: :new_record?

  private

  def uniques
    return unless self.class.where(name: name, skill_category_id: skill_category_id).exists?
    errors.add('name & skill_category', 'must be uniq')
  end
end
