class CreateDraftSkill < ActiveRecord::Migration
  def change
    create_table :draft_skills do |t|
      t.integer :requester_id, index: true
      t.integer :reviewer_id, index: true
      t.references :skill_category, index: true, foreign_key: true
      t.references :skill, index: true, foreign_key: true

      t.string :name
      t.string :description
      t.string :rate_type

      t.string :draft_type
      t.string :draft_status

      t.string :requester_explanation
      t.string :reviewer_explanation

      t.timestamps
    end
  end
end
