module Memberships
  class UpdateBooked
    def initialize(membership_ids)
      @membership_ids = Array(membership_ids)
    end

    def call(value = false)
      return if @membership_ids.empty?
      Membership.where(id: clear_ids).update_all(booked: value)
    end

    private

    def clear_ids
      @membership_ids.reject(&:empty?)
    end
  end
end
