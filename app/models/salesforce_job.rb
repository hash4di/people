class SalesforceJob < ActiveRecord::Base
  validates :operation, inclusion: { in: %w(delete insert upsert update) }

end
