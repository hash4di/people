module Api::V2
  class UserSkillRatesSerializer < ActiveModel::Serializer
    attributes :ref_name, :rate

    def ref_name
      object.skill.ref_name
    end
  end
end
