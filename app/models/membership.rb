class Membership < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :project, inverse_of: :memberships
  belongs_to :role

  validates :user, presence: true
  validates :project, presence: true
  validates :role, presence: true
  validates :starts_at, presence: true
  validates :billable, inclusion: { in: [true, false] }

  validate :validate_starts_at_ends_at
  validate :validate_duplicate_project
  validates_with Membership::StartDateValidator
  validates_with Membership::EndDateValidator

  after_create :notify_slack_on_create
  after_save :check_fields
  after_update :notify_slack_on_update

  scope :non_potential, -> { where(project_potential: false) }
  scope :non_booked, -> { where(booked: false) }
  scope :non_archived, -> { where(project_archived: false) }
  scope :archived, -> { where(project_archived: true) }
  scope :active, -> { non_archived.non_booked.non_potential }
  scope :only_active_user, -> { joins(:user).where(users: { archived: false } ) }
  scope :potential, -> { where(project_potential: true) }
  scope :with_role, -> (role) { where(role: role) }
  scope :with_user, -> (user) { where(user: user) }
  scope :without_user, -> (user) { where('user_id != ?', user.id) }
  scope :without_project, -> (project_name) do
    joins(:project).where.not(projects: { name: project_name })
  end
  scope :with_project, -> (project) { where(project: project) }
  scope :overlaps, -> (starts_at, ends_at) do
    where(
      '(starts_at, COALESCE(ends_at, :now)) overlaps (:starts_at, :ends_at)',
      starts_at: starts_at, ends_at: ends_at, now: Time.zone.now
    )
  end
  scope :unfinished, -> do
    joins(:project)
      .where(
        'COALESCE(projects.end_at, :now) >= :now AND COALESCE(memberships.ends_at, :now) >= :now',
        now: Date.current.beginning_of_day
      )
  end
  scope :started, -> { where('memberships.starts_at <= NOW()') }
  scope :not_started, -> { where('memberships.starts_at > NOW()') }
  scope :billable, -> { where(billable: true) }
  scope :non_billable, -> { where(billable: false) }
  scope :booked, -> { where(booked: true) }
  scope :without_bookings, -> { where(booked: false) }
  scope :only_active, -> { active.order(starts_at: :desc).limit(3) }
  scope :not_internal, -> { where(project_internal: false) }

  def self.next_memberships
    not_started = arel_table[:starts_at].gt(Time.current)
    not_potential = arel_table[:project_potential].eq(false)
    not_booked = arel_table[:booked].eq(false)

    unfinished.where(not_started.and(not_potential).and(not_booked))
  end

  def self.qualifying
    has_end_date = arel_table[:ends_at].not_eq(nil)
    is_billable = arel_table[:billable].eq(true)
    no_end_date = arel_table[:ends_at].eq(nil)

    where(has_end_date.or(is_billable.and(no_end_date)))
  end

  def started?
    starts_at <= Date.current && !booked
  end

  def terminated?
    ends_at&.to_date.try('<', Date.current) || false
  end

  def active?
    started? && !terminated?
  end

  def end_now!
    if starts_at < Date.current && (ends_at.nil? || ends_at > Date.current)
      update(ends_at: Date.current)
    end
  end

  def duration_in_months
    ((Time.current - starts_at.to_time) / UserDecorator::DAYS_IN_MONTH).round
  end

  private

  def check_fields
    if project_state_changed?
      update_columns(
        project_potential: project.potential,
        project_archived: project.archived,
        project_internal: project.internal
      )
    end
  end

  def project_state_changed?
    (project_potential != project.potential) ||
      (project_archived != project.archived) ||
      (project_internal != project.internal)
  end

  def validate_starts_at_ends_at
    if starts_at.present? && ends_at.present? && starts_at > ends_at
      errors.add(:ends_at, "can't be before starts_at date")
    end
  end

  def validate_duplicate_project
    MembershipCollision.new(self).call
  end

  def notify_slack_on_create
    SlackNotifier.new.ping(NotificationMessage::Membership::Created.new(self))
  end

  def notify_slack_on_update
    SlackNotifier.new.ping(NotificationMessage::Membership::Updated.new(self))
  end
end
