module Api
  module V2
    class UserSkillRatesQuery
      attr_reader :scope_params

      def initialize(scope_params)
        @scope_params = scope_params
      end

      def call
        user_skill_rates
      end

      private

      def user_id_by_email
        email = scope_params[:user_email][0...-2]
        User.where('email LIKE ?', "#{email}%").pluck(:id)
      end

      def user_ids
        if scope_params[:scope] == 'user' && scope_params[:user_email]
          user_id_by_email
        elsif  scope_params[:scope] == 'all'
          User.technical_active.pluck(:id)
        else
          []
        end
      end

      def user_skill_rates
        UserSkillRate.joins(:skill, :user).select(select_fields).rated.where(
          user_id: user_ids
        )
      end

      def select_fields
        'user_skill_rates.rate, skills.ref_name, users.email'
      end
    end
  end
end
