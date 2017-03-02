module Notifications
  class SkillUpdatedJob
    include SuckerPunch::Job

    def perform(draft_skill_id:)
      ::Notifications::Skill::Updated.new(
        notifiable_id: draft_skill_id
      ).notify
    end
  end
end
