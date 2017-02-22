module Notifications
  class SkillUpdatedJob
    include SuckerPunch::Job

    def perform(skill_id:)
      ::Notifications::Skill::Updated.new(
        notifiable_id: skill_id
      ).notify
    end
  end
end
