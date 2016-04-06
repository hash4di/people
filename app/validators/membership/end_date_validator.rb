class Membership
  class EndDateValidator < ::Base::DatesChronologyValidator
    protected

    def starts_at
      record.ends_at
    end

    def ends_at
      record.project&.end_at
    end

    def error_field
      :ends_at
    end

    def error_message
      I18n.t('validators.dates.membership_ends_after_project_ended')
    end
  end
end
