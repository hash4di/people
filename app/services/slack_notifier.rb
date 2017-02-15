class SlackNotifier
  attr_reader :options

  def initialize(options = {})
    @options = options.reverse_merge(default_options)
  end

  def ping(notification)
    return unless (webhook_url = AppConfig.slack.webhook_url).present?
    return unless (message = notification.message).present?

    unless Rails.env.development?
      Slack::Notifier.new(webhook_url, options).ping(message)
    end
  end

  private

  def default_options
    { username: AppConfig.slack.username }
  end
end
