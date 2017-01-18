class SkillSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :rate_type
  has_one :skill_category
end
