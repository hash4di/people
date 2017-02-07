class NullRole
  def name
    'No Role'.freeze
  end

  def skill_category
    @skill_category ||= NullSkillCategory.new
  end
end
