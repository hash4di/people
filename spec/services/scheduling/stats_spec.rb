require 'spec_helper'

describe Scheduling::Stats do
  let!(:intern) { create(:user, :intern) }
  let!(:junior) { create(:user, :junior) }
  let!(:interns_and_juniors) do
    create(:membership, user: intern,  project: create(:project))
    create(:membership, user: junior,  project: create(:project))
  end
  let!(:commercial_project_without_due_date) do
    project = create(:project, :without_due_date, :commercial)
    build(:scheduled_users_hash, project: project)
  end
  let!(:commercial_project_with_due_date) do
    project = create(:project, :commercial)
    build(:scheduled_users_hash, project: project)
  end
  let!(:internal_project) do
    project = create(:project, :internal)
    build(:scheduled_users_hash, project: project)
  end
  let!(:unavailable) do
    project = UnavailableProjectBuilder.new.call
    build(:scheduled_users_hash, project: project)
  end
  let!(:not_scheduled) do
    create(:user, :developer)
  end

  let(:repository) { ScheduledUsersRepository.new }
  let(:admin_mode) { true }

  subject { described_class.new(repository, admin_mode) }

  let(:expected_stats) do
    {
      all: 35,
      juniors_and_interns: 2,
      to_rotate: 2,
      in_internals: 4,
      with_rotations_in_progress: 6,
      in_commercial_projects_with_due_date: 6,
      booked: 6,
      unavailable: 8,
      not_scheduled: 1
    }
  end

  it 'return proper numbers' do
    stats = subject.get
    aggregate_failures do
      expected_stats.each do |k, v|
        expect(stats.fetch(k)).to eq(v)
      end
    end
  end
end
