module Apiguru
  class ShowProjectInfo
    def initialize(params)
      @name = params[:name]
    end

    def call
      storage.detect { |x| x[:name] == @name }
    end

    private

    def storage
      Apiguru::Client.client
    end
  end
end
