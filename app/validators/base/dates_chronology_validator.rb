module Base
  class DatesChronologyValidator < ActiveModel::Validator
    def validate(record)
      @record = record
      raise_error unless dates_in_chronological_order
    end

    protected

    def starts_at
      raise NotImplementedError
    end

    def ends_at
      raise NotImplementedError
    end

    def error_field
      :end_at
    end

    def error_message
      I18n.t('validators.dates.chronology')
    end

    def raise_error
      record.errors.add(error_field, error_message)
    end

    private

    attr_reader :record

    def dates_in_chronological_order
      return true if starts_at.nil? || ends_at.nil?
      starts_at <= ends_at
    end
  end
end
