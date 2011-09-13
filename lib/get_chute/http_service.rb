module Chute
  class GCRequest
    include HTTParty
    #require File.join(RAILS_ROOT, "/config/chute_configuration.rb")
    
    API_URL = 'api.developer.getchute.com/v1'
    API_KEY = "OAuth c33a36237da089bb5bfa252faf72469a0871a20ff0f50143afbac16ee7caa1e9"
    
    HEADERS = {"authorization" => API_KEY}
  
    base_uri  API_URL
    headers   HEADERS

    def get(url, params=nil) 
      GCResponse.new(GCRequest.get(url, {:body => params}))
    end
    
    def post(url, params=nil)
      GCResponse.new(GCRequest.post(url, {:body => params}))
    end
    
    def put(url, params=nil)
      GCResponse.new(GCRequest.put(url, {:body => params}))
    end
    
    def delete(url, params=nil)
      GCResponse.new(GCRequest.delete(url, {:body => params}))
    end

  end

  class GCResponse
    attr_reader :raw_response, :data, :errors, :object, :status, :is_success
    def initialize(attributes = {})
      @raw_response     = attributes
      @status           = attributes.response.code
      @errors           = []
      parse(attributes.parsed_response)
    end
    
    def parse(parsed_response)
      if status.to_i <= 300
        if parsed_response["errors"]
          @is_success = false
          parsed_response["errors"].each do |error|
            @errors << error
          end
        else
          @is_success = true
          @data       = parsed_response["data"]
        end
      else
        @is_success = false
        @errors << parsed_response["error"]
      end
    end
    
    def objectify(class_name)
      
    end
  end
end