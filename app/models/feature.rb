class Feature < ActiveRecord::Base
  extend Flip::Declarable

  strategy Flip::CookieStrategy
  strategy Flip::DatabaseStrategy
  strategy Flip::DeclarationStrategy
  default false

  feature :modifying_skills_allowed, description: 'Allow user to modify skills'
  feature :salesforce_skills_sync, description: 'Syncs skills and user skill rates between People and Salesforce', default: Rails.env.production?
end
