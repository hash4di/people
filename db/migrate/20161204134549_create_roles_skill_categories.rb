class CreateRolesSkillCategories < ActiveRecord::Migration
  def change
    create_table :roles_skill_categories do |t|
      t.references :role, index: true, foreign_key: true
      t.references :skill_category, index: true, foreign_key: true
    end
  end
end
