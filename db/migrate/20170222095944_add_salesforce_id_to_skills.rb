class AddSalesforceIdToSkills < ActiveRecord::Migration
  def change
    add_column :skills, :salesforce_id, :string
    add_index :skills, :salesforce_id
  end
end
