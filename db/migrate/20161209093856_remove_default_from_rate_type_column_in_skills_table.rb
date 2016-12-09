class RemoveDefaultFromRateTypeColumnInSkillsTable < ActiveRecord::Migration
  def change
    change_column_default :skills, :rate_type, nil
  end
end
