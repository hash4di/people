class AddMarkedForDeleteToSkillsAndDraftSkills < ActiveRecord::Migration
  def change
    add_column :skills, :marked_for_delete, :boolean, default: false
    add_column :draft_skills, :marked_for_delete, :boolean, default: false
  end
end
