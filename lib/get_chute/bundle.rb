module Chute
  class GCBundle < GCResource
    attr_accessor :id,
                  :url,
                  :shortcut,
                  :x_asset_ids
    
    def initialize(attributes={})
      super
      @id           = attributes[:id]
      @url          = attributes[:url]
      @shortcut     = attributes[:shortcut]
      @x_asset_ids  = attributes[:x_asset_ids]
    end
    
    def save
      perform(self.class.post("/#{resource_name}", {"#{resource_name.singularize}" => attributes, :asset_ids => x_asset_ids}))
    end
    
    def self.all
      raise NotImplementedError
    end
    
    def resource_name
      'bundles'
    end
  end
end