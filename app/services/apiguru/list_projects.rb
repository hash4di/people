module Apiguru
  class ListProjects
    def call
      storage
        .select { |x| x[:project_active] == true }
        .map { |x| x[:name] }
        .sort_by(&:downcase)
    end

    private

    def storage
      Apiguru::Client.client
    end
  end
end
