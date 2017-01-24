module Skills
  class RateType
    TYPES = {
      'boolean' => 0..1,
      'range' => 0..3,
    }.freeze

    def initialize(type:)
      @type = type.to_s
    end

    attr_reader :type

    def expected_range
      TYPES.fetch(type) { ::NullObjects::NullObject.new }
    end

    def self.stringified_types
      TYPES.keys.map(&:to_s)
    end
  end
end
