class MembershipsRepository
  def all
    Membership.includes(:project, :user, :role).all
  end

  def active_ongoing
    Membership.unfinished.not_archived
  end

  def upcoming_changes(number_of_days)
    # FIXME: it should be more friendly
    Membership.includes(:project)
      .where("(memberships.ends_at BETWEEN ? AND ?) OR (memberships.starts_at BETWEEN ? AND ?)",
             Time.now,
             number_of_days.days.from_now,
             Time.now,
             number_of_days.days.from_now
            )
  end
end
