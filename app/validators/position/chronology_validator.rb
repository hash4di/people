class Position
  class ChronologyValidator < ActiveModel::Validator
    STARTS_AT_INDEX = 0
    PRIORITY_INDEX = 1

    def validate(record)
      return if record.errors.any? || chronology_valid?(record)

      record.errors.add(:starts_at, I18n.t('positions.errors.chronology'))
    end

    private

    def chronology_valid?(position)
      positions = Position.includes(:role).where(user: position.user).order(:starts_at)
        .pluck('positions.starts_at, roles.priority')
      previous_positions_have_less_or_equal_priority?(positions, position) &&
        next_positions_have_greater_or_equal_priority?(positions, position)
    end

    def previous_positions_have_less_or_equal_priority?(positions, new_position)
      previous_positions(positions, new_position).all? do |previous_position|
        previous_position[PRIORITY_INDEX] <= new_position.role.priority
      end
    end

    def next_positions_have_greater_or_equal_priority?(positions, new_position)
      next_positions(positions, new_position).all? do |next_position|
        next_position[PRIORITY_INDEX] >= new_position.role.priority
      end
    end

    def previous_positions(positions, new_position)
      positions.select do |position|
        position[STARTS_AT_INDEX] < new_position.starts_at
      end
    end

    def next_positions(positions, new_position)
      positions.select do |position|
        position[STARTS_AT_INDEX] > new_position.starts_at
      end
    end
  end
end
