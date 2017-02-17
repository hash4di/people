module Notifications
  class SkillCreatedJob
    include SuckerPunch::Job

    def perform(skill_id:)
      ::Notifications::Skill::Created.new(
        notifiable_id: skill_id
      ).notify
    end
  end
end
