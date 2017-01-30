class SkillsRepository
  def all
    @all ||= Skill.order(name: :asc)
  end
end
