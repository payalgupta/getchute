module Chute
  class GCBundle < GCResource
    attr_accessor :id,
                  :url,
                  :shortcut
    
    def initialize(attributes={})
      super
      @id           = attributes[:id]
      @url          = attributes[:url]
      @shortcut     = attributes[:shortcut]
    end
    
    def resource_name
      'bundles'
    end
    
    def destroy
      raise NotImplementedError
    end

    #================================================#
    # Asset Management                               #
    #================================================#
    
    def add_assets(asset_ids)
      response = self.class.post("/bundles/#{id}/add", :asset_ids => "#{asset_ids}")
      response.is_success
    end
    
    def remove_assets(asset_ids)
      response = self.class.post("/bundles/#{id}/remove", :asset_ids => "#{asset_ids}")
      response.is_success
    end
    
    #================================================#
    # Class Methods                                  #
    #================================================#
    
    def self.find_by_id(id)
      bundle = Chute::GCBundle.new
      bundle.perform(get("/bundles/#{id}")) ? bundle : false
    end
    
    def self.class_path
      "bundles"
    end

  end
end