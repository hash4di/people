class BaseSkillRatesGeneratorJob
  include SuckerPunch::Job

  def perform(user_id:)
    Skills::UserSkillRatesGenerator.new(user_id: user_id).call
  end
end
