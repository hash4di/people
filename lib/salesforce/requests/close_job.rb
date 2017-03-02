module Salesforce::Requests
  class CloseJob < Salesforce::Requests::Base
    attr_reader :item, :session

    def initailize(item, session)
      @item = item
      @session = session
    end


    def url
      "https://#{session.server_url.host}/services/async/#{API_VERSION}/job/#{item.salesforce_id}"
    end

    def options
      { headers: headers, body: request_body.to_s }
    end

    def headers
      { 'Content-Type' => 'application/json', 'charset' => 'UTF-8', 'X-SFDC' => session[:token] }
    end
  end
end
