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

  end
end