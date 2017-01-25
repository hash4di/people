class SchedulingController < ApplicationController
  before_filter :authenticate!, only: [:not_scheduled]

  expose(:users) do
    ActiveModel::ArraySerializer.new(
      ScheduledUsersRepository.new.technical,
      each_serializer: UserSchedulingSerializer
    ).as_json
  end
  expose(:roles) do
    ActiveModel::ArraySerializer.new(
      RolesRepository.new.all_technical,
      each_serializer: RoleSerializer
    ).as_json
  end
  expose(:skills) do
    ActiveModel::ArraySerializer.new(
      SkillsRepository.new.all,
      each_serializer: SkillFilterSerializer
    ).as_json
  end

  expose(:stats) do
    Scheduling::Stats.new(repository, current_user.admin?).get
  end

  expose(:columns) do
    Scheduling::ColumnSetsBuilder.new.call[action_name]
  end

  def all
    self.users = serialized_users(repository.all)
    render :index
  end

  def juniors_and_interns
    self.users = serialized_users_sorted(repository.scheduled_juniors_and_interns)
    render :index
  end

  def to_rotate
    self.users = serialized_users_sorted(repository.to_rotate)
    render :index
  end

  def in_internals
    self.users = serialized_users_sorted(repository.in_internals)
    render :index
  end

  def with_rotations_in_progress
    self.users = serialized_users_sorted(repository.with_rotations_in_progress)
    render :index
  end

  def in_commercial_projects_with_due_date
    self.users = serialized_users(
      Scheduling::Sorting::ByCurrentMembershipEndDate.sort(
        repository.in_commercial_projects_with_due_date
      )
    )
    render :index
  end

  def booked
    self.users = serialized_users_sorted(repository.booked)
    render :index
  end

  def unavailable
    self.users = serialized_users_sorted(repository.unavailable)
    render :index
  end

  def not_scheduled
    self.users = serialized_users(repository.not_scheduled)
    render :index
  end

  private

  def serialized_users(users)
    ActiveModel::ArraySerializer.new(
      users,
      each_serializer: UserSchedulingSerializer
    ).as_json
  end

  def serialized_users_sorted(users)
    ActiveModel::ArraySerializer.new(
      Scheduling::Sorting::ByCurrentMembershipStartDate.sort(users),
      each_serializer: UserSchedulingSerializer
    ).as_json
  end

  def repository
    @repository ||= ScheduledUsersRepository.new
  end

  def authenticate!
    redirect_to scheduling_index_path unless current_user.admin?
  end

  def number_of(collection)
    collection.distinct.count
  end
end
