class UserSkillRate
  class RateWithinRangeValidator < ActiveModel::Validator
    def validate(record)
      @record = record

      add_error unless rate_within_range?
    end

    protected 

    attr_reader :record

    def rate_within_range?
      rate_type = record.user_skill_rate&.skill&.rate_type
      expected_range = ::Skills::RateType.new(type: rate_type).expected_range

      expected_range.include?(record.rate)
    end

    def add_error
      record.errors.add('skill', I18n.t('errors.messages.inclusion'))
    end
  end
end

