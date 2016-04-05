class Membership
  class StartDateValidator < ::Base::DatesChronologyValidator
    protected

    def starts_at
      record.starts_at
    end

    def ends_at
      record.project&.end_at
    end

    def error_field
      :starts_at
    end

    def error_message
      I18n.t('validators.dates.membership_starts_after_project_end_date')
    end
  end
end
