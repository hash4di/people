class ChangeDefaultValueForNoteOnUserSkillRates < ActiveRecord::Migration
  def change
    change_column :user_skill_rates, :note, :string, default: ""
  end
end
