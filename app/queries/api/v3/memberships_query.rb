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
        date_in_future = Time.zone.now + 1.month
        ends_at = membership.ends_at || date_in_future
        Membership.only_active_user.without_user(
          user
        ).with_project(membership.project).overlaps(
          membership.starts_at, ends_at
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
