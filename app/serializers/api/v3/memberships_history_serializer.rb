module Api
  module V3
    class MembershipsHistorySerializer < ActiveModel::Serializer
      attributes :project_name, :user_name, :user_email, :user_role, :id

      def project_name
        object.project.name
      end

      def user_role
        object.role.name
      end

      def user_name
        "#{object.user.first_name} #{object.user.last_name}"
      end

      def user_email
        object.user.email
      end
    end
  end
end
