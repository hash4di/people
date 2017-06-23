module Api
  module V3
    class MembershipsQuery
      attr_reader :filter_params

      def all_overlapped(filter_params)
        @filter_params = filter_params
        all_overlapped = all_user_memberhips.map do |membership|
          overlapped_with(membership)
        end
        all_overlapped.flatten
      end

      private

      def overlapped_with(membership)
        starts_at = filter_params[:f2f_date]
        ends_at = membership.ends_at || 1.month.from_now
        Membership.only_active_user.without_user(
          user
        ).with_project(membership.project).overlaps(
          starts_at, ends_at
        )
      end

      def all_user_memberhips
        @all_user_memberhips ||= Membership.with_user(user).without_project(
          'Internals'
        ).overlaps(
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
