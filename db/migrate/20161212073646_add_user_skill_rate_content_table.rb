class AddUserSkillRateContentTable < ActiveRecord::Migration
  def change
    create_table :user_skill_rate_contents do |t|
      t.integer :rate, default: 0
      t.references :user_skill_rate, index: true

      t.timestamps
    end

    remove_column :user_skill_rates, :rate
  end
end
