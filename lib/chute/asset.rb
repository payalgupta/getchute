module Chute
  class GCAsset < GCResource
    
    attr_accessor :id,
                  :url,
                  :share_url,
                  :is_portrait

    def initialize(attributes = {})
      super
      @id           = attributes[:id]
      @url          = attributes[:url]
      @share_url    = attributes[:share_url]
      @is_portrait  = attributes[:is_portrait]
    end
    
    def resource_name
      'assets'
    end
    
    def custom_url(height, width)
      "#{url}/#{height}x#{width}" if url
    end
    
    #================================================#
    # Class Methods                                  #
    #================================================#
    
    def self.find_by_id(id)
      asset = Chute::GCAsset.new
      asset.perform(get("/assets/#{id}")) ? asset : false
    end
    
    def self.class_path
      "assets"
    end
    
    def self.heart(id)
      response = get("/assets/#{id}/heart")
      response.is_success
    end
    
    def self.unheart(id)
      response = get("/assets/#{id}/unheart")
      response.is_success
    end
    
    def self.remove(ids=[])
      response = post("/assets/remove", {:asset_ids => ids})
      response.is_success
    end
    
    def self.verify(files=[])
      files = [{
        :url    => "Users/payalgupta/Desktop/39-Dcroe.jpg",
        :size   => 34500,
        :md5    => 34500
      }]
      # files = ["Users/payalgupta/Desktop/39-Dcroe.jpg"]
      response = post("/assets/verify", {:files => files})
      response
    end

  end
end