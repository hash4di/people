class CreateRatesForSkillJob
  include SuckerPunch::Job

  def perform(skill_id:)
    Skills::UserSkillRatesGenerator.new.generate_single_for_all_users(
      skill_id: skill_id
    )
  end
end
