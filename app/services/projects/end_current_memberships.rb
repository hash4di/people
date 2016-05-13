module Projects
  class EndCurrentMemberships
    def initialize(project)
      @project = project
    end

    def call
      current_project_memberships.each do |membership|
        membership.update(ends_at: Date.current.end_of_day)
      end
    end

    private

    attr_reader :project

    def current_project_memberships
      project
        .memberships
        .where('memberships.ends_at IS NULL OR memberships.ends_at > ?', Time.now)
    end
  end
end
