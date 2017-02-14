class CreateRatesForUserJob
  include SuckerPunch::Job

  def perform(user_id:)
    Skills::UserSkillRatesGenerator.new.generate_all_for_user(user_id: user_id)
  end
end
