class ChangeRelationBetweenSkillCategoriesAndRoles < ActiveRecord::Migration
  def up
    remove_index :roles_skill_categories, name: :index_roles_skill_categories_on_role_id
    remove_index :roles_skill_categories, name: :index_roles_skill_categories_on_skill_category_id

    drop_table :roles_skill_categories

    add_reference :roles, :skill_category, index: true
  end

  def down
    create_table :roles_skill_categories do |t|
      t.integer :role_id
      t.integer :skill_category_id
    end

    add_index :roles_skill_categories, [:role_id], name: :index_roles_skill_categories_on_role_id
    add_index :roles_skill_categories, [:skill_category_id], name: :index_roles_skill_categories_on_skill_category_id

    remove_reference :roles, :skill_category, index: true
  end
end
