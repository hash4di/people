class Project
  class DatesChronologyValidator < ::Base::DatesChronologyValidator
    protected

    def starts_at
      record.starts_at
    end

    def ends_at
      record.end_at
    end
  end
end
