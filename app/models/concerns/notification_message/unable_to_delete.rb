module NotificationMessage
  class UnableToDelete
    pattr_initialize %i[api_name object error]

    def message
      I18n.t(
        'notification_message',
        class: object.class.name,
        type: object.class.name.underscore,
        id: object.id,
        sf_id: object.salesforce_id,
        api_name: api_name,
        message: error.message
      )
    end
  end
end
