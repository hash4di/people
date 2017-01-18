module NullObjects
  class NullObject
    private

    def method_missing(*_args, &_block)
      nil
    end
  end
end
