module Apiguru
  class ListProjects < Client
    def call
      storage
        .select { |x| x[:project_active] == true }
        .map { |x| x[:name] }
        .sort_by(&:downcase)
    end

    private

    def storage
      Apiguru::Client.client(url)
    end

    def url
      AppConfig.apiguru.projects_url
    end

  end
end
