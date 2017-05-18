module Api
  module V3
    class TeamSerializer < ActiveModel::Serializer
      attributes :id, :name, :color
    end
  end
end
