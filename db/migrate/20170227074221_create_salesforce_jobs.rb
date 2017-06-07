class CreateSalesforceJobs < ActiveRecord::Migration
  def change
    create_table :salesforce_jobs do |t|
      t.string :operation, null: false
      t.string :object, null: false
      t.string :content_type, null: false
      t.string :salesforce_id, null: false
      t.string :status, null: false
    end

    add_index :salesforce_jobs, :salesforce_id
  end
end
