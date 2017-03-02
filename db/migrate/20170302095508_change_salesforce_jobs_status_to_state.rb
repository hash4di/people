class ChangeSalesforceJobsStatusToState < ActiveRecord::Migration
  def change
    rename_column :salesforce_jobs, :status, :state
  end
end
