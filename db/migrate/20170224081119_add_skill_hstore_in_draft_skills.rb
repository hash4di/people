class AddSkillHstoreInDraftSkills < ActiveRecord::Migration
  def change
    enable_extension 'hstore'
    add_column :draft_skills, :original_skill_details, :hstore
  end
end
