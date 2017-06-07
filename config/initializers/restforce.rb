Restforce.configure do |config|
  salesforce = AppConfig.salesforce

  config.client_id = salesforce.client_id
  config.client_secret = salesforce.client_secret
  config.username = salesforce.username
  config.password = salesforce.password
  config.security_token = salesforce.security_token
  config.host = salesforce.host
  config.api_version = '38.0'
end
