class AddSalesforceIdToUserSkillRates < ActiveRecord::Migration
  def change
    add_column :user_skill_rates, :salesforce_id, :string
  end
end
