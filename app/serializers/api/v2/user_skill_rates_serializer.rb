module Api::V2
  class UserSkillRatesSerializer < ActiveModel::Serializer
    attributes :ref_name, :rate, :email
  end
end
