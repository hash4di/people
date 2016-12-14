module Scheduling
  class Stats
    def initialize(repository, admin_mode)
      @repository = repository
      @admin_mode = admin_mode
    end

    def get
      @stats ||= {
        all: count_sql(repository.all),
        juniors_and_interns: count_sql(repository.scheduled_juniors_and_interns),
        to_rotate: count_sql(repository.to_rotate),
        in_internals: count_sql(repository.in_internals),
        with_rotations_in_progress: count_sql(repository.with_rotations_in_progress),
        in_commercial_projects_with_due_date: count_sql(repository.in_commercial_projects_with_due_date),
        booked: count_sql(repository.booked),
        unavailable: count_sql(repository.unavailable),
      }
      @stats[:not_scheduled] ||= count_sql(repository.not_scheduled) if admin_mode
      @stats
    end

    private

    attr_reader :repository, :admin_mode

    def count_sql(query)
      ActiveRecord::Base
        .connection
        .execute("SELECT COUNT(*) FROM ( #{query.to_sql} ) AS res")
        .entries[0]['count']
        .to_i
    end
  end
end
