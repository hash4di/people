module Api
  module V3
    class TeamMemberSerializer < ActiveModel::Serializer
      attributes :id, :email, :full_name

      def full_name
        "#{object.first_name} #{object.last_name}"
      end
    end
  end
end
