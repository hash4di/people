module NotificationMessage
  module Skill
    class UnableToDelete
      attr_reader :api_name, :object, :error

      def initialize(api_name:, object:, error:)
        @api_name = api_name
        @object = object
        @error = error
      end

      def message
        "Unable to delete skill from Salesforce (`skill_id: #{object.id}, sf_id: "\
        "#{object.salesforce_id}, api_name: #{api_name}`)\nError message: `#{error.message}`"
      end
    end
  end
end
