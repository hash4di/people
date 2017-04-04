module Api
  module V3
    class MembershipsQuery
      attr_reader :filter_params

      def all_overlapped(filter_params)
        @filter_params = filter_params
        all_overlapped = all_user_memberhips.map do |membership|
          Membership.without_user(user).where(
            project_id: membership.project_id
          ).overlaps(membership.starts_at, membership.ends_at)
        end
        all_overlapped.flatten
      end

      private

      def all_user_memberhips
        @all_user_memberhips ||= Membership.with_user(user).overlaps(
          filter_params[:f2f_date], Time.zone.now
        )
      end

      def user
        @user ||= begin
          email = filter_params[:user_email][0...-2]
          User.where('email LIKE ?', "#{email}%").first
        end
      end
    end
  end
end
