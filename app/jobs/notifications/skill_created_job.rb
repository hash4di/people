module Notifications
  class SkillCreatedJob
    include SuckerPunch::Job

    def perform(draft_skill_id:)
      ::Notifications::Skill::Created.new(
        notifiable_id: draft_skill_id
      ).notify
    end
  end
end
