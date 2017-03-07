namespace :mailer do
  task ending_projects: :environment do
    ProjectDigest.ending_in_a_week.each do |project|
      SendMailJob.perform_async(ProjectMailer, :ending_soon, project)
    end
  end

  task three_months_old: :environment do
    ProjectDigest.three_months_old.each do |project|
      SendMailJob.perform_async(ProjectMailer, :three_months_old, project)
    end
  end

  task kickoff_tomorrow: :environment do
    ProjectDigest.starting_tomorrow.each do |project|
      SendMailJob.perform_async(ProjectMailer, :kickoff_tomorrow, project)
    end
  end

  desc 'Email about users that are in the project more than six months'
  task users_with_rotation_need: :environment do
    ScheduledUsersRepository.new.to_rotate.each do |user|
      long_memberships = user.current_memberships.select do |membership|
        membership.starts_at < 6.months.ago
      end

      long_memberships.each do |membership|
        SendMailJob.perform_async(UserMailer, :notify_membership_duration, user, membership)
      end
    end
  end

  desc 'Email about users that have some unread notifications'
  task users_with_unread_notifications: :environment do
    unread_notifications_count = %((select count(*) FROM notifications WHERE notifications.receiver_id = users.id AND notifications.notification_status = 'unread'))

    users = User.active.joins(
      :notifications
    ).select(
      'users.*', "#{unread_notifications_count} AS unread_notifications_count"
    ).group(:id).having(
      "#{unread_notifications_count} > 0"
    )

    users.each do |user|
      SendMailJob.perform_async(UserMailer, :notify_unread_notifications, user)
    end
  end

  desc 'Email about users that miss primary role in their profiles'
  task users_without_primary_role: :environment do
    user_ids_with_primary = Position.select(:user_id).primary.distinct.pluck(:user_id)
    users_without_primary =
      User
      .active
      .where.not(id: user_ids_with_primary)
      .where(primary_role: nil)
      .order([:last_name, :first_name])

    next if users_without_primary.size.zero?
    SendMailJob.perform_async(UserMailer, :without_primary_role, users_without_primary)
  end

  desc 'Email upcoming changes to projects'
  task changes_digest: :environment do
    digest_days = AppConfig.emails.notifications.changes_digest.days
    ProjectDigest.upcoming_changes(digest_days).each do |project|
      SendMailJob.perform_async(ProjectMailer, :upcoming_changes, project, digest_days)
    end
  end
end
