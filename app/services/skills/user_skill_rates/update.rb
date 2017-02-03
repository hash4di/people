module Skills
  module UserSkillRates
    class Update
      def initialize(user_skill_rate_id:, params:)
        @user_skill_rate_id = user_skill_rate_id
        @params = params
      end

      def call
        update_user_skill_rate
        create_or_update_user_skill_rate_content
        remove_last_content if last_two_contents_are_equal?
        user_skill_rate
      end

      private

      attr_reader :user_skill_rate_id, :params

      def update_user_skill_rate
        user_skill_rate.update(update_params)
      end

      def create_or_update_user_skill_rate_content
        if user_skill_rate_content
          user_skill_rate_content.update(update_params)
        else
          user_skill_rate.contents.create(params)
        end
      end

      def user_skill_rate_content
        @user_skill_rate_content ||= user_skill_rate.contents.today.last
      end

      def user_skill_rate
        @user_skill_rate ||= ::UserSkillRate.find(user_skill_rate_id)
      end

      def update_params
        @update_params ||= params.slice(:note, :rate, :favorite)
      end

      def last_two_contents_are_equal?
        contents = user_skill_rate.reload.contents.last(2)
        return false if contents.length < 2
        content_attributes(contents[0]) == content_attributes(contents[1])
      end

      def content_attributes(content)
        content.attributes.slice('rate', 'note', 'favorite')
      end

      def remove_last_content
        user_skill_rate.contents.last.destroy
      end
    end
  end
end
