module Salesforce
  class DestroyObjectService
    SLACK_CHANNEL = '#notyfikacje-people'.freeze

    def call(api_name:, object:, notify: false)
      salesforce_id = object.salesforce_id
      return false if salesforce_id.nil?

      begin
        sf_object = sf_client.find(api_name, salesforce_id)
      rescue Faraday::ClientError => error
        error_params = { error: error, api_name: api_name, object: object }
        send_notifications(error_params) if notify
        return false
      end

      !!sf_object&.destroy
    end

    private

    def sf_client
      @sf_client ||= Restforce.new
    end

    def slack_notifier
      @slack_notifier ||= SlackNotifier.new(channel: SLACK_CHANNEL)
    end

    def send_notifications(error_params)
      rollbar_notification(error_params)
      slack_notification(error_params)
    end

    def rollbar_notification(error_params)
      Rollbar.error(
        error_params[:error], 'Unable to delete SF record',
        api_name: error_params[:api_name],
        object: error_params[:object]
      )
    end

    def slack_notification(error_params)
      slack_notifier.ping(
        NotificationMessage::Skill::UnableToDelete.new(error_params)
      )
    end
  end
end
