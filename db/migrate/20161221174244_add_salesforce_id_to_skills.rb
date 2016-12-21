class AddSalesforceIdToSkills < ActiveRecord::Migration
  def change
    add_column :skills, :salesforce_id, :string
  end
end
